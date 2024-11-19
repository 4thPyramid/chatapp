import 'dart:async';
import 'package:logger/logger.dart';  // استيراد مكتبة logger
import 'package:chatapp/core/services/chat/messages.dart';
import 'package:chatapp/pages/data/domain/repos/caht_repo/caht_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_cupit_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  final Logger logger = Logger();
  StreamSubscription? _messageSubscription;

  ChatCubit({required this.chatRepo}) : super(ChatInitial());

  Future<void> checkIfChatExists(String currentUserId, String otherUserId) async {
    emit(ChatLoading());
    logger.i('Checking if chat exists between $currentUserId and $otherUserId');
    final result = await chatRepo.checkIfChatExists(currentUserId, otherUserId);
    result.fold(
      (failure) {
        logger.e('Error: ${failure.message}');
        if (!isClosed) emit(ChatError(failure.message));
      },
      (chatId) {
        if (chatId != null) {
          logger.i('Chat exists with ID: $chatId');
          if (!isClosed) emit(ChatChatExists(chatId: chatId));
        } else {
          logger.i('No chat found between the users');
          if (!isClosed) emit(ChatNoChatFound());
        }
      },
    );
  }

  Future<void> sendMessage(String chatId, String senderId, String receiverId, String text) async {
    try {
      emit(ChatLoading());
      logger.i('Sending message from $senderId to $receiverId in chat $chatId');
      final result = await chatRepo.sendMessage(chatId, senderId, receiverId, text);

      result.fold(
        (failure) {
          logger.e('Error sending message: ${failure.message}');
          if (!isClosed) emit(ChatError(failure.message));
        },
        (_) => listenToMessages(chatId),  // استمع للرسائل الجديدة بعد إرسال الرسالة
      );
    } catch (e) {
      logger.e('Error sending message: $e');
      if (!isClosed) emit(ChatError(e.toString()));
    }
  }

  void listenToMessages(String chatId) {
    _messageSubscription?.cancel(); // إلغاء أي اشتراك سابق
    final messagesStream = chatRepo.getMessages(chatId); // الحصول على تدفق الرسائل من الـ repo
    _messageSubscription = messagesStream.listen(
      (messages) {
        logger.i('Loaded ${messages.length} messages for chat $chatId');
        if (!isClosed) emit(ChatMessagesLoaded(messages: messages));  // تحديث الحالة بالرسائل الجديدة
      },
      onError: (error) {
        if (!isClosed) emit(ChatError('Error fetching messages: $error'));  // التعامل مع الأخطاء
      },
    );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel(); // إلغاء الاشتراك عند الإغلاق
    return super.close();
  }
}
