import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // تنفيذ الـ onPressed عند النقر
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0XFFF9FAFA), // لون الخلفية
          borderRadius: BorderRadius.circular(10), // حواف دائرية
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25), // حشو الزر
        margin: const EdgeInsets.symmetric(horizontal: 25), // هوامش على الجوانب

        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary, // لون النص (يتم تحديده بناءً على theme)
              fontSize: 16, // حجم الخط
              fontWeight: FontWeight.bold, // سمك الخط
            ),
          ),
        ),
      ),
    );
  }
}
