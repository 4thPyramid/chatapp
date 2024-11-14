part of 'chat_cupit_cubit.dart';

@immutable
sealed class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

class ChatMessageSent extends ChatState {}

class ChatChatsLoaded extends ChatState {
  final List<Chat> chats;

  ChatChatsLoaded({required this.chats});
}

// الحالة الجديدة عند تحميل المستخدم بنجاح
class ChatUserLoaded extends ChatState {
    final Chat chat; 


  ChatUserLoaded({required this.chat});
}
