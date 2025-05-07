import 'package:flutter/material.dart';
import 'widgets/caht_body_view.dart';

class ChatView extends StatelessWidget {
  static const String routeName = '/chat';

  final String chatId;
  final String userId;
  final String userName;
  final String receiverId;

  const ChatView({
    super.key,
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return ChatBodyView(
      chatId: chatId,
      userId: userId,
      userName: userName,
      receiverId: receiverId,
    );
  }
}
