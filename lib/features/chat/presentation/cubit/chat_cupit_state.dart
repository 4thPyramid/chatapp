// chat_cupit_state.dart

part of 'chat_cupit_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

class ChatMessageSent extends ChatState {}

class ChatMessagesLoaded extends ChatState {
  final List<MessageModel> messages;

  ChatMessagesLoaded({required this.messages});
}

class ChatChatExists extends ChatState {
  final String chatId;

  ChatChatExists({required this.chatId});
}

class ChatNoChatFound extends ChatState {}
