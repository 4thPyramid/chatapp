import 'package:chatapp/core/services/get_it_service.dart';
import 'package:chatapp/features/auth/presentation/cupits/login_cupit/login_cubit.dart';
import 'package:chatapp/features/auth/presentation/views/wedgets/login_view_boddy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(getIt()),
      child: const Scaffold(
        body: LoginViewBody(), // تمرير التحكم إلى LoginViewBody
      ),
    );
  }
}
