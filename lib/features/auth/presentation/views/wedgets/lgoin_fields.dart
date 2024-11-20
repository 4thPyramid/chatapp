import 'package:chatapp/features/auth/presentation/views/wedgets/custom_button.dart';
import 'package:chatapp/core/widgets/custom_text_field.dart';
import 'package:chatapp/core/widgets/password_field.dart';
import 'package:flutter/material.dart';

class LoginFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String? email, String? password) onLogin;

  const LoginFields({
    super.key,
    required this.formKey,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    String? email;
    String? password;

    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextField(
            hint: 'Email',
            textInputType: TextInputType.emailAddress,
            onSaved: (value) => email = value,
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
            onSaved: (value) => password = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Login',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                onLogin(email, password);
              }
            },
          ),
        ],
      ),
    );
  }
}
