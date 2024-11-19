import 'package:chatapp/features/auth/presentation/views/wedgets/register_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/features/auth/presentation/cupits/register_cupit/regster_cubit.dart';
import 'package:chatapp/features/auth/presentation/views/login_view.dart';
import 'package:chatapp/features/home/presentation/views/home_page_view.dart';
import 'package:chatapp/core/services/get_it_service.dart';

import 'wedgets/text_rich.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  static const routeName = '/register';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onRegister(String name, String email, String password) {
    context.read<RegsterCubit>().registerWithEmailAndPassword(email, password, name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegsterCubit>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocConsumer<RegsterCubit, RegsterState>(
          listener: (context, state) {
            if (state is RegsterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is RegsterSuccess) {
              Navigator.pushReplacementNamed(context, HomeView.routeName);
            }
          },
          builder: (context, state) {
            return Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.message, size: 60, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 50),
                      Text(
                        'Create your account',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 25),
                      RegisterFields(
                        formKey: _formKey,
                        onRegister: _onRegister,
                      ),
                      const SizedBox(height: 10),
                      if (state is RegsterLoading) const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      TextRich( firstText: 'Already a member?',
                        secondText: ' ',
                        linkText: 'Login now',
                        onLinkTap: () {
                          Navigator.of(context).pushReplacementNamed(LoginView.routeName);
                        },)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
