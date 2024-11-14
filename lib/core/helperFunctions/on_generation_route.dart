import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/pages/login_page.dart';
import 'package:chatapp/pages/register_page.dart';
import 'package:chatapp/pages/settings_page.dart';
import 'package:flutter/material.dart';


Route<dynamic> onGenerateRoute(  RouteSettings settings ) {
  switch (settings.name) {
   case LoginPage.routeName:
    return MaterialPageRoute(builder: (context) =>   LoginPage());
    case RegisterPage.routeName:
    return MaterialPageRoute(builder: (context) =>   RegisterPage());
    case HomePage.routeName:
    return MaterialPageRoute(builder: (context) => const  HomePage());
    case SettingsPage.routeName:
    return MaterialPageRoute(builder: (context) => const  SettingsPage());
    case ChatPage.routeName:
    return MaterialPageRoute(builder: (context) => const  ChatPage());
 
    default:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
    
}