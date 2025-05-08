import 'dart:async';
import 'package:chatapp/core/models/message_model.dart';
import 'package:chatapp/core/services/chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'chat_cupit_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService chatService;
  final Logger logger = Logger();
  StreamSubscription? _messageSubscription;

  ChatCubit({required this.chatService}) : super(ChatInitial());

  Future<void> createOrLoadChat(String otherUserId) async {
    emit(ChatLoading());
    try {
      final chatId = await chatService.createChat(otherUserId);
      emit(ChatChatExists(chatId: chatId));
      listenToMessages(chatId);
    } catch (e) {
      emit(ChatError('Failed to load or create chat: $e'));
    }
  }

  Future<void> sendMessage(String chatId, MessageModel message) async {
    emit(ChatLoading());
    try {
      await chatService.sendMessage(chatId, message);
      listenToMessages(chatId); // إعادة الاستماع بعد الإرسال
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }

  void listenToMessages(String chatId) {
    _messageSubscription?.cancel();
    _messageSubscription = chatService.getMessages(chatId).listen(
          (messages) => emit(ChatMessagesLoaded(messages: messages)),
          onError: (e) => emit(ChatError('Error loading messages: $e')),
        );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
