import 'package:chatapp/features/auth/presentation/views/wedgets/text_rich.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/features/auth/presentation/cupits/register_cupit/regster_cubit.dart';
import 'package:chatapp/features/auth/presentation/views/login_view.dart';
import 'package:chatapp/features/auth/presentation/views/wedgets/register_fields.dart';
import 'package:chatapp/features/home/presentation/views/home_view.dart';


class RegisterViewBody extends StatefulWidget {
  const RegisterViewBody({super.key});

  @override
  State<RegisterViewBody> createState() => _RegisterViewBodyState();
}

class _RegisterViewBodyState extends State<RegisterViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onRegister(String name, String email, String password) {
    context.read<RegsterCubit>().registerWithEmailAndPassword(email, password, name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegsterCubit, RegsterState>(
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
          child: SingleChildScrollView(
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
                     " Let's create an account for you",
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
                    TextRich(
                      firstText: 'Already a member?',
                      secondText: ' ',
                      linkText: 'Login now',
                      onLinkTap: () {
                        Navigator.of(context).pushReplacementNamed(LoginView.routeName);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
