import 'package:chatapp/core/helperFunctions/on_generation_route.dart';
import 'package:chatapp/core/services/get_it_service.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/features/auth/presentation/views/login_view.dart';
import 'package:chatapp/core/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setup();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your applicatin.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoute,
      initialRoute: LoginView.routeName,
      theme: lightmode,
      
    );
  }
}

