import 'package:chatapp/core/models/chat_model.dart';
import 'package:chatapp/core/models/message_model.dart';
import 'package:chatapp/core/models/user_model.dart';
import 'package:chatapp/core/services/notification/fcm_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// جلب المستخدمين الآخرين (ما عدا الحالي)
  Stream<List<UserModel>> getOtherUsersStream() {
    final uid = currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != uid)
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// إرسال رسالة وتحديث المحادثة وإرسال إشعار
  Future<void> sendMessage(String chatId, MessageModel message) async {
    try {
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();

      await messageRef.set(message.toMap());

      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message.text,
        'timestamp': message.timestamp,
      });

      await FCMService.sendNotificationToUser(
        receiverId: message.receiverId,
        title: 'رسالة جديدة',
        body: message.text,
        data: {
          'chatId': chatId,
        },
      );

      print('✅ Message sent: ${message.text}');
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }

  /// استرجاع رسائل دردشة معينة
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
  }

  /// استرجاع محادثات المستخدم
  Stream<List<ChatModel>> getUserChats() {
    final uid = currentUser?.uid;
    if (uid == null) return Stream.value([]);

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// إنشاء محادثة أو إعادة استخدامها
  Future<String> createChat(String otherUserId) async {
    final uid = currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    final existing = await _firestore
        .collection('chats')
        .where('participants', arrayContains: uid)
        .get();

    for (var doc in existing.docs) {
      final participants = List<String>.from(doc.data()['participants']);
      if (participants.contains(otherUserId)) return doc.id;
    }

    final chatRef = await _firestore.collection('chats').add({
      'participants': [uid, otherUserId],
      'lastMessage': '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    return chatRef.id;
  }
}
