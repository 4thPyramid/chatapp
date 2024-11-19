import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/features/chat/presentation/cubit/chat_cupit_cubit.dart';

class ChatPage extends StatelessWidget {
  static const String routeName = '/chat';
  final String chatId;
  final String userId;
  final String userName;
  final String receiverId;

  const ChatPage({
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final chatCubit = GetIt.instance<ChatCubit>();
        chatCubit.checkIfChatExists(userId, receiverId);  // تحقق من وجود الدردشة
        chatCubit.listenToMessages(chatId);  // استماع للرسائل عند الدخول
        return chatCubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(userName),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error: ${state.message}'),
                    ));
                  }
                },
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is ChatMessagesLoaded) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isSentByUser = message.senderId == userId;
                        return ListTile(
                          title: Text(
                            message.text,
                            style: TextStyle(
                              color: isSentByUser ? Colors.blue : Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            isSentByUser ? 'You' : userName,
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No messages'));
                  }
                },
              ),
            ),
            MessageInput(
              chatId: chatId,
              senderId: userId,
              receiverId: receiverId,
            ),
          ],
        ),
      ),
    );
  }
}
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
