import 'package:chatapp/core/errors/failures.dart';
import 'package:chatapp/core/services/chat/chat.dart';
import 'package:chatapp/core/services/chat/messages.dart';
import 'package:chatapp/core/services/chat_service.dart';
import 'package:chatapp/features/chat/data/caht_repo/caht_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRepoImpl implements ChatRepo {
  final ChatService chatService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatRepoImpl({required this.chatService});

  /// إرسال رسالة
  @override
  Future<Either<Failure, void>> sendMessage(
      String chatId, String senderId, String receiverId, String text) async {
    try {
      // إضافة الرسالة إلى مجموعة الرسائل
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'text': text,
        'senderId': senderId,
        'receiverId': receiverId, // إضافة receiverId
        'timestamp': FieldValue.serverTimestamp(),
      });

      // تحديث بيانات المحادثة الرئيسية
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Message sent: $text to chat $chatId by user $senderId');
      return Right(null); // تم إرسال الرسالة بنجاح
    } catch (e) {
      print('Error sending message: $e');
      return Left(
          ServerFailure('Error sending message: ${e.toString()}')); // إعادة خطأ
    }
  }

  /// جلب الرسائل
  /// جلب المستخدم الحالي
  @override
  Future<Either<Failure, Chat?>> getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return Right(null); // لا يوجد مستخدم مسجل
      }

      final querySnapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final chat = Chat.fromFirestore(querySnapshot.docs.first);
        return Right(chat);
      } else {
        return Right(null); // لم يتم العثور على محادثة
      }
    } catch (e) {
      return Left(
          ServerFailure('Error fetching current user chat: ${e.toString()}'));
    }
  }

  /// التحقق من وجود المحادثة بين المستخدمين
  @override
  Future<Either<Failure, String?>> checkIfChatExists(
      String currentUserId, String otherUserId) async {
    try {
      final querySnapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .get();

      for (var doc in querySnapshot.docs) {
        final participants = List<String>.from(doc['participants']);
        if (participants.contains(otherUserId)) {
          return Right(doc.id); // المحادثة موجودة
        }
      }

      return const Right(null); // المحادثة غير موجودة
    } catch (e) {
      return Left(
          ServerFailure('Error checking chat existence: ${e.toString()}'));
    }
  }

  /// جلب المحادثات الخاصة بالمستخدم الحالي
}
