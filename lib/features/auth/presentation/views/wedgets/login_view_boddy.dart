
import 'package:chatapp/features/auth/presentation/cupits/login_cupit/login_cubit.dart';
import 'package:chatapp/features/auth/presentation/cupits/login_cupit/login_state.dart';
import 'package:chatapp/features/auth/presentation/views/wedgets/lgoin_fields.dart';
import 'package:chatapp/features/auth/presentation/views/wedgets/text_rich.dart';
import 'package:chatapp/features/home/presentation/views/home_view.dart';
import 'package:chatapp/features/auth/presentation/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onLogin(String? email, String? password) {
    context.read<LoginCubit>().loginWithEmailAndPassword(email!, password!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, HomeView.routeName);
        }
      },
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message,
                      size: 60, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 50),
                  Text(
                    'Welcome back, you have been missed!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 25),
                  LoginFields(
                    formKey: _formKey,
                    onLogin: _onLogin,
                  ),
                  const SizedBox(height: 10),
                  if (state is LoginLoading) const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  TextRich(
                    firstText: 'Not a member?',
                    secondText: ' ',
                    linkText: 'Register now',
                    onLinkTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(RegisterView.routeName);
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
