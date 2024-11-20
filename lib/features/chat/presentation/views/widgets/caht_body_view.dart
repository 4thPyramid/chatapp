import 'package:chatapp/features/chat/presentation/views/widgets/message_input.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../cubit/chat_cupit_cubit.dart';

class ChatBodyView extends StatelessWidget {
  const ChatBodyView({
    super.key,
    required this.userId,
    required this.receiverId,
    required this.chatId,
    required this.userName,
  });

  final String userId;
  final String receiverId;
  final String chatId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final chatCubit = GetIt.instance<ChatCubit>();
        chatCubit.checkIfChatExists(userId, receiverId);
        chatCubit.listenToMessages(chatId);  
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