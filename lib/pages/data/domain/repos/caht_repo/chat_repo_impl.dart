import 'package:chatapp/core/errors/failures.dart';
import 'package:chatapp/core/services/chat/chat.dart';
import 'package:chatapp/core/services/chat/messages.dart';
import 'package:chatapp/core/services/chat_service.dart';
import 'package:chatapp/pages/data/domain/repos/caht_repo/caht_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';  // استيراد FirebaseAuth

class ChatRepoImpl implements ChatRepo {
  final ChatService chatService;

  ChatRepoImpl({required this.chatService});

  @override
  Future<Either<Failure, void>> sendMessage(String chatId, String userId, String text) async {
    try {
      await chatService.sendMessage(chatId, userId, text);
      return Right(null); // الرسالة اتبعتت بنجاح
    } catch (e) {
      return Left(ServerFailure(e.toString()));  // لو في مشكلة مع السيرفر
    }
  }

  @override
  Stream<List<Message>> getMessages(String chatId) {
    return chatService.getMessages(chatId);
  }

  @override
  Future<Either<Failure, List<Chat>>> getChats() async {
    try {
      // هنا نقوم بجلب الدردشات من الـ Firestore
      final chatDocs = await chatService.getChats();
      
      // التأكد من أن الكود يقوم بتحويل الـ DocumentSnapshot إلى كائن Chat بشكل صحيح
      final chats = chatDocs.map((doc) {
        return Chat.fromFirestore(doc); // تحويل الوثيقة إلى كائن Chat
      }).toList();

      return Right(chats);  // إذا كانت العملية ناجحة
    } catch (e) {
      return Left(ServerFailure(e.toString()));  // لو في مشكلة مع السيرفر
    }
  }

  @override
  Future<Either<Failure, Chat?>> getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // جلب الـ Chat الخاص بالمستخدم من Firestore
        final chatDoc = await FirebaseFirestore.instance
            .collection('chats')
            .where('userId', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (chatDoc.docs.isNotEmpty) {
          final chat = chatDoc.docs.first;
          return Right(Chat.fromFirestore(chat));  // إرجاع الـ Chat ككائن
        } else {
          return Right(null);  // إذا لم يكن هناك دردشة للمستخدم
        }
      } else {
        return Right(null);  // إذا لم يكن هناك مستخدم مسجل دخول
      }
    } catch (e) {
      // في حالة حدوث أي استثناء آخر
      return Left(ServerFailure(e.toString()));
    }
  }
}
