import 'package:chatapp/components/custom_button.dart';
import 'package:chatapp/components/custom_text_field.dart';
import 'package:chatapp/components/password_field.dart';
import 'package:chatapp/core/services/get_it_service.dart';
import 'package:chatapp/pages/home_page.dart';
import 'package:chatapp/pages/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/pages/cupits/login_cupit/login_cubit.dart';
import 'package:chatapp/pages/cupits/login_cupit/login_state.dart';
import '../core/helperFunctions/shared_prefrencess.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocProvider(
        create: (_) => LoginCubit(getIt()),
        child: Form(
          key: _formKey,
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is LoginSuccess) {
                _prefsService.saveUserData(state.userEntity.email, state.userEntity.uid);
                Navigator.pushReplacementNamed(context, HomePage.routeName);
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message, size: 60, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 50),
                  Center(
                    child: Text(
                      'Welcome back, you have been missed!',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    hint: 'Email',
                    textInputType: TextInputType.emailAddress,
                    onSaved: (value) => _email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  PasswordField(
                    hint: 'Password',
                    onSaved: (value) => _password = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: state is LoginLoading ? 'Logging in...' : 'Login',
                    onPressed: state is LoginLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              context.read<LoginCubit>().loginWithEmailAndPassword(_email!, _password!);
                            }
                          },
                  ),
                  const SizedBox(height: 10),
                  if (state is LoginLoading) const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Not a member?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary, fontSize: 13),
                        ),
                        const TextSpan(text: ' ', style: TextStyle(color: Colors.transparent)),
                        TextSpan(
                          text: 'Register now',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacementNamed(RegisterPage.routeName);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
