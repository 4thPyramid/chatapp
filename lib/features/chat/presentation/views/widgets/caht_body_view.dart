import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../cubit/chat_cupit_cubit.dart';
import 'message_input.dart';

class ChatBodyView extends StatelessWidget {
  final String userId;
  final String receiverId;
  final String chatId;
  final String userName;

  const ChatBodyView({
    super.key,
    required this.userId,
    required this.receiverId,
    required this.chatId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<ChatCubit>()..checkIfChatExists(userId, receiverId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(userName),
        ),
        body: Column(
          children: [
            BlocListener<ChatCubit, ChatState>(
              listenWhen: (previous, current) => current is ChatChatExists,
              listener: (context, state) {
                if (state is ChatChatExists) {
                  context.read<ChatCubit>().listenToMessages(state.chatId);
                }
              },
              child: Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChatMessagesLoaded) {
                      final filteredMessages = state.messages
                          .where((msg) =>
                              (msg.senderId == userId &&
                                  msg.receiverId == receiverId) ||
                              (msg.senderId == receiverId &&
                                  msg.receiverId == userId))
                          .toList();

                      if (filteredMessages.isEmpty) {
                        return const Center(child: Text("No messages"));
                      }

                      return ListView.builder(
                        reverse: true,
                        itemCount: filteredMessages.length,
                        itemBuilder: (context, index) {
                          final message = filteredMessages[index];
                          final isSentByUser = message.senderId == userId;

                          return Align(
                            alignment: isSentByUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSentByUser
                                    ? Colors.blueAccent
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                message.text,
                                style: TextStyle(
                                  color: isSentByUser
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ChatError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }

                    return const SizedBox.shrink();
                  },
                ),
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
