import 'package:chatapp/features/chat/presentation/views/chat_view.dart';
import 'package:chatapp/features/home/presentation/views/home_view.dart';
import 'package:chatapp/features/auth/presentation/views/login_view.dart';
import 'package:chatapp/features/auth/presentation/views/register_view.dart';
import 'package:chatapp/features/auth/presentation/views/settings_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginView.routeName:
      return MaterialPageRoute(builder: (context) => const LoginView());
    case RegisterView.routeName:
      return MaterialPageRoute(builder: (context) => const RegisterView());
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());
    case SettingsPage.routeName:
      return MaterialPageRoute(builder: (context) => const SettingsPage());
    case ChatView.routeName:
  final arguments = settings.arguments as Map<String, dynamic>;
  return MaterialPageRoute(
    builder: (context) => ChatView(
      chatId: arguments['chatId'],
      userId: arguments['userId'],
      userName: arguments['userName'],
      receiverId: arguments['receiverId'], 
    ),
  );

    default:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
}
