import 'package:chatapp/core/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/core/services/firebase_auth_service.dart';

class CustomUserTile extends StatelessWidget {
  const CustomUserTile({super.key, required this.user});

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final currentUser = FirebaseAuthService().getCurrentUser();
        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You need to sign in first!')),
          );
          return;
        }

        try {
          // إنشاء دردشة جديدة والحصول على معرف الدردشة
          final chatId = await GetIt.instance<ChatService>().createChat(user['uid']);

          // الانتقال إلى صفحة الدردشة مع تمرير المعطيات
          Navigator.of(context).pushNamed(
            ChatPage.routeName,
            arguments: {
              'chatId': chatId,
              'userId': currentUser.uid, // معرف المستخدم الحالي
              'userName': user['name'],  // اسم المستخدم المستهدف
              'receiverId': user['uid'], // معرف المستقبل
            },
          );
        } catch (e) {
          // التعامل مع الأخطاء
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create chat: $e')),
          );
        }
      },
      child: ListTile(
        title: Text(user['name'] ?? 'No Name'),
        subtitle: Text(user['email'] ?? 'No Email'),
      ),
    );
  }
}
