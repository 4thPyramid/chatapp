import 'package:bloc/bloc.dart';
import 'package:chatapp/core/services/chat/chat.dart';
import 'package:chatapp/core/services/chat/messages.dart';
import 'package:meta/meta.dart';
import 'package:logger/logger.dart';

import '../../data/domain/repos/caht_repo/caht_repo.dart';

part 'chat_cupit_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepo chatRepo;
  final Logger logger;

  ChatCubit({required this.chatRepo})
      : logger = Logger(printer: PrettyPrinter()),
        super(ChatInitial());

  // دالة لجلب المستخدم الحالي (يتعامل الآن مع كائن Chat)
  void getCurrentUser() async {
    logger.i("getCurrentUser called");
    try {
      final result = await chatRepo.getCurrentUser(); // يتم الآن جلب كائن Chat
      result.fold(
        (failure) {
          logger.e("Error getting current user: ${failure.message}");
          emit(ChatError(failure.message));
        },
        (chat) {
          if (chat != null) {
            logger.i("Current user loaded successfully: ${chat.userEmail}");
            emit(ChatUserLoaded(chat:  chat));  // إرسال كائن Chat
          } else {
            logger.i("No chat found for current user.");
            emit(ChatError("No chat found for current user"));
          }
        },
      );
    } catch (e) {
      logger.e("Exception in getCurrentUser: $e");
      emit(ChatError(e.toString()));
    }
  }

  // إرسال رسالة
  Future<void> sendMessage(String chatId, String userId, String text) async {
    logger.i("sendMessage called with chatId: $chatId, userId: $userId, text: $text");
    emit(ChatLoading());
    try {
      final result = await chatRepo.sendMessage(chatId, userId, text);
      result.fold(
        (failure) {
          logger.e("Error sending message: ${failure.message}");
          emit(ChatError(failure.message));
        },
        (_) {
          logger.i("Message sent successfully.");
          emit(ChatMessageSent());
        },
      );
    } catch (e) {
      logger.e("Exception in sendMessage: $e");
      emit(ChatError(e.toString()));
    }
  }

  // جلب الرسائل
  Stream<List<Message>> getMessages(String chatId) {
    logger.i("getMessages called for chatId: $chatId");
    return chatRepo.getMessages(chatId);
  }

  // جلب قائمة الدردشات
  Future<void> getChats() async {
    logger.i("getChats called");
    try {
      emit(ChatLoading());
      final result = await chatRepo.getChats();
      result.fold(
        (failure) {
          logger.e("Error getting chats: ${failure.message}");
          emit(ChatError(failure.message));
        },
        (chats) {
          logger.i("Chats loaded successfully: ${chats.length} chats found.");
          emit(ChatChatsLoaded(chats: chats));
        },
      );
    } catch (e) {
      logger.e("Exception in getChats: $e");
      emit(ChatError(e.toString()));
    }
  }
}
