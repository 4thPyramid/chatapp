import 'package:chatapp/features/home/presentation/views/widgets/custom_drawer.dart';
import 'package:chatapp/core/widgets/custom_user_tile.dart';
import 'package:chatapp/core/services/chat_service.dart';
import 'package:chatapp/core/services/firebase_auth_service.dart';
import 'package:chatapp/features/auth/presentation/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:get_it/get_it.dart';
import 'package:chatapp/features/chat/presentation/cubit/chat_cupit_cubit.dart'; 

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final chatService = GetIt.instance<ChatService>();
    final currentUser = GetIt.instance<FirebaseAuthService>().getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await GetIt.instance<FirebaseAuthService>().logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
                Navigator.of(context).pushReplacementNamed(LoginView.routeName);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const CustomDrawer(),
      body:  BlocProvider(
  create: (context) => GetIt.instance<ChatCubit>(), 
  child: StreamBuilder<List<Map<String, dynamic>>>(
    stream: chatService.getOtherUsersStream(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No other users found"));
      }

      final users = snapshot.data!.where((user) => user['email'] != currentUser?.email).toList();

      if (users.isEmpty) {
        return const Center(child: Text("No other users found"));
      }

      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return CustomUserTile(user: user);
        },
      );
    },
  ),
),
  );
  }
}

