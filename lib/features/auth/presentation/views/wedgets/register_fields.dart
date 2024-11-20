import 'package:chatapp/features/auth/presentation/views/wedgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/core/widgets/custom_text_field.dart';
import 'package:chatapp/core/widgets/password_field.dart';

class RegisterFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(String name, String email, String password) onRegister;

  const RegisterFields({
    super.key,
    required this.formKey,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    String? name;
    String? email;
    String? password;

    return Column(
      children: [
        CustomTextField(
          hint: 'Full Name',
          onSaved: (value) => name = value,
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
          onSaved: (value) => email = value,
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
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              onRegister(name!, email!, password!);
            }
          },
          text: 'Register'
        ),
      ],
    );
  }
}
