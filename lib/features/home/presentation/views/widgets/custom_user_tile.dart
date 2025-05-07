import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/core/services/chat_service.dart';
import 'package:chatapp/core/services/firebase_auth_service.dart';
import 'package:chatapp/features/chat/presentation/views/chat_view.dart';

class CustomUserTile extends StatelessWidget {
  final Map<String, dynamic> user;

  const CustomUserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user['name']),
      subtitle: Text(user['email']),
      onTap: () async {
        final currentUser = GetIt.I<FirebaseAuthService>().getCurrentUser();
        if (currentUser == null) return;

        try {
          final chatId = await GetIt.I<ChatService>().createChat(user['uid']);
          Navigator.of(context).pushNamed(
            ChatView.routeName,
            arguments: {
              'chatId': chatId,
              'userId': currentUser.uid,
              'receiverId': user['uid'],
              'userName': user['name'],
            },
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating chat: $e')),
          );
        }
      },
    );
  }
}
