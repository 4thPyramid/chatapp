import 'package:chatapp/core/models/message_model.dart' show MessageModel;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../cubit/chat_cupit_cubit.dart';

class MessageInput extends StatefulWidget {
  final String chatId;
  final String senderId;
  final String receiverId;

  const MessageInput({
    super.key,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      GetIt.I<ChatCubit>().sendMessage(
        widget.chatId,
        MessageModel(
          senderId: widget.senderId,
          receiverId: widget.receiverId,
          text: text,
          timestamp: DateTime.now(),
        ),
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
