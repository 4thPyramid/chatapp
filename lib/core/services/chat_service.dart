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

  // دالة لجلب بيانات جميع المستخدمين الآخرين كـ Stream
  Stream<List<Map<String, dynamic>>> getOtherUsersStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]); // إعادة Stream فارغ إذا لم يكن هناك مستخدم.

    return _firestore.collection('users').snapshots().map((snapshot) {
      // تصفية المستخدمين لاستبعاد المستخدم الحالي
      return snapshot.docs
          .where((doc) => doc.id != currentUser.uid)
          .map((doc) => doc.data())
          .toList();
    });
  }

  // جلب بيانات جميع المستخدمين الآخرين
  Future<List<Map<String, dynamic>>> getAllOtherUsers() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return [];

    final querySnapshot = await _firestore.collection('users').get();

    return querySnapshot.docs
        .where((doc) => doc.id != currentUser.uid)
        .map((doc) => doc.data())
        .toList();
  }

  // إرسال رسالة نصية
  Future<void> sendMessage(String chatId, String userId, String text) async {
    try {
      await _firestore.collection('chats').doc(chatId).collection('messages').add({
        'text': text,
        'senderId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error sending message: $e');
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

  // جلب قائمة الدردشات
  Future<List<DocumentSnapshot>> getChats() async {
    try {
      final querySnapshot = await _firestore.collection('chats').get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching chats: $e');
      return [];
    }
  }
}
