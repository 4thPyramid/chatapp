import 'package:chatapp/core/services/chat/chat.dart';
import 'package:chatapp/core/services/chat/messages.dart';
import 'package:dartz/dartz.dart'; // للـ Either و التعامل مع الـ errors بشكل مرتب
import 'package:chatapp/core/errors/failures.dart';

abstract class ChatRepo {
  // إرسال رسالة مع إضافة senderId و receiverId
  Future<Either<Failure, void>> sendMessage(
      String chatId, String senderId, String receiverId, String text);

  // استرجاع الرسائل الخاصة بمحادثة معينة

  // جلب المحادثات الخاصة بالمستخدم الحالي

  // التحقق من وجود المحادثة بين المستخدمين
  Future<Either<Failure, String?>> checkIfChatExists(
      String currentUserId, String otherUserId);

  // جلب المستخدم الحالي
  Future<Either<Failure, Chat?>> getCurrentUser();
}
