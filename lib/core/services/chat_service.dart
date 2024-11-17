import 'package:chatapp/core/services/chat/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // دالة للحصول على المستخدم الحالي
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // دالة لجلب جميع المستخدمين الآخرين (ما عدا المستخدم الحالي)
  Stream<List<Map<String, dynamic>>> getOtherUsersStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]); // إعادة Stream فارغ إذا لم يكن هناك مستخدم.

    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != currentUser.uid)
          .map((doc) => {
                ...doc.data(),
                'name': doc.data()['name'] ?? 'Unknown',
                'email': doc.data()['email'] ?? 'No Email',
              })
          .toList();
    });
  }

  // إرسال رسالة إلى محادثة معينة
  Future<void> sendMessage(String chatId, String senderId, String receiverId, String text) async {
    try {
      // إضافة الرسالة إلى مجموعة الرسائل
      await _firestore.collection('chats').doc(chatId).collection('messages').add({
        'text': text,
        'senderId': senderId,
        'receiverId': receiverId,  // إضافة receiverId
        'timestamp': FieldValue.serverTimestamp(),
      });

      // تحديث بيانات المحادثة الرئيسية
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Message sent: $text to chat $chatId by user $senderId to $receiverId');
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // استرجاع الرسائل الخاصة بدردشة معينة
  Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromFirestore(doc);
      }).toList();
    });
  }

  // جلب جميع المحادثات الخاصة بالمستخدم الحالي
  Stream<List<Map<String, dynamic>>> getUserChats() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]);

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // إنشاء محادثة جديدة بين المستخدمين
  Future<String> createChat(String otherUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is logged in');
    }

    try {
      // التحقق من وجود محادثة مسبقة
      final existingChat = await _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUser.uid)
          .get();

      for (var doc in existingChat.docs) {
        final participants = doc.data()['participants'] as List;
        if (participants.contains(otherUserId)) {
          print('Chat already exists: ${doc.id}');
          return doc.id; // إرجاع chatId للمحادثة الموجودة
        }
      }

      // إذا لم تكن هناك محادثة موجودة، إنشاء محادثة جديدة
      final chatRef = await _firestore.collection('chats').add({
        'participants': [currentUser.uid, otherUserId],
        'lastMessage': 'No messages yet',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('New chat created: ${chatRef.id}');
      return chatRef.id;
    } catch (e) {
      print('Error creating chat: $e');
      throw Exception('Failed to create chat');
    }
  }
}
