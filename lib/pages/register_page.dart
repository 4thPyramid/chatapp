import 'package:chatapp/core/helperFunctions/shared_prefrencess.dart';
import 'package:chatapp/pages/cupits/register_cupit/regster_cubit.dart';
import 'package:chatapp/pages/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:chatapp/components/custom_button.dart';
import 'package:chatapp/components/custom_text_field.dart';
import 'package:chatapp/components/password_field.dart';
import 'package:chatapp/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  String? _name, _email, _password;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegsterCubit>(
      create: (context) => GetIt.instance<RegsterCubit>(), // تصحيح الاسم
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: BlocConsumer<RegsterCubit, RegsterState>( // تصحيح الاسم
          listener: (context, state) {
            if (state is RegsterFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is RegsterSuccess) {
              _prefsService.saveUserData(_email!, _name!);
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message, size: 60, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 50),
                  CustomTextField(
                    hint: 'Full Name',
                    onSaved: (value) => _name = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    textInputType: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hint: 'Email',
                    textInputType: TextInputType.emailAddress,
                    onSaved: (value) => _email = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value)) {
                        return 'Enter a valid email';
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
                    text: state is RegsterLoading ? 'Registering...' : 'Register',
                    onPressed: state is RegsterLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              context.read<RegsterCubit>().registerWithEmailAndPassword(_email!, _password!,_name!);
                            }
                          },
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already a member?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary, fontSize: 13),
                        ),
                        const TextSpan(text: ' ', style: TextStyle(color: Colors.transparent)),
                        TextSpan(
                          text: 'Login now',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
