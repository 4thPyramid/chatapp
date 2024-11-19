import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.hint,
    this.suffixIcon,
    required this.textInputType,
    this.onSaved,
    this.obsecureText = false,
    this.validator,  // أضفنا هذه الخاصية
  });

  final String? hint;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final void Function(String?)? onSaved;
  final bool obsecureText;
  final String? Function(String?)? validator;  // إضافة النوع الصحيح للـ validator

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        validator: validator ?? (value) {  // إذا كان تم تمرير validator خارجي، يتم استخدامه، وإلا نستخدم validator الافتراضي
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        obscureText: obsecureText,
        onSaved: onSaved,
        keyboardType: textInputType,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          filled: true,
          fillColor: const Color(0XFFF9FAFA),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          hintText: hint,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
