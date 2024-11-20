import 'package:chatapp/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key, required this.onSaved, required this.hint, this.validator,
  });

  final void Function(String?)? onSaved;
  final String hint;
  final String? Function(String?)? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      obsecureText: obscureText,
      onSaved: widget.onSaved,
      hint: widget.hint,
      textInputType: TextInputType.visiblePassword,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
        child: obscureText
            ? const Icon(Icons.visibility_off, color: Color(0XFFC9CECF))
            : const Icon(Icons.visibility, color: Color(0XFFC9CECF)),
      ),
      validator: widget.validator,  // تمرير الـ validator هنا
    );
  }
}
