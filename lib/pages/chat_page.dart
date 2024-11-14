import 'package:chatapp/core/services/chat/chat.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  static const String routeName = '/chat';

  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;

    return Scaffold(
      appBar: AppBar(
        title: Text(chat.userEmail),  // عرض إيميل المستخدم في عنوان الصفحة
      ),
      body: Center(
        child: Text('Chat with ${chat.userEmail}'),  // يمكنك إضافة رسائل الدردشة هنا
      ),
    );
  }
}
