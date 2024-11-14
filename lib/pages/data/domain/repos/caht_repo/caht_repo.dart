import 'package:chatapp/core/services/chat/chat.dart';
import 'package:chatapp/core/services/chat/messages.dart';
import 'package:dartz/dartz.dart';  // للـ Either و التعامل مع الـ errors بشكل مرتب
import 'package:chatapp/core/errors/failures.dart';

abstract class ChatRepo {
  // إرسال رسالة
  Future<Either<Failure, void>> sendMessage(String chatId, String userId, String text);

  // استرجاع الرسائل
  Stream<List<Message>> getMessages(String chatId);
  
  // جلب قائمة الدردشات
  Future<Either<Failure, List<Chat>>> getChats();
  
  // جلب المستخدم الحالي
 Future< Either<Failure, Chat?>> getCurrentUser();
}
