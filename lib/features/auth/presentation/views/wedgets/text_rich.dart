import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextRich extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String linkText;
  final VoidCallback onLinkTap;

  const TextRich({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.linkText,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: firstText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 13,
            ),
          ),
          const TextSpan(text: ' ', style: TextStyle(color: Colors.transparent)),
          TextSpan(
            text: linkText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
          ),
        ],
      ),
    );
  }
}
