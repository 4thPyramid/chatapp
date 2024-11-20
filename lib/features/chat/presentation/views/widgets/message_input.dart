 import 'package:chatapp/features/chat/presentation/cubit/chat_cupit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // إرسال الرسالة باستخدام ChatCubit
      GetIt.instance<ChatCubit>().sendMessage(
        widget.chatId,
        widget.senderId,
        widget.receiverId,
        _controller.text,
      );
      _controller.clear(); // تنظيف الحقل بعد الإرسال
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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