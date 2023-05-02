import 'package:flutter/material.dart';

class LoginSignupButton extends StatelessWidget {
  const LoginSignupButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.title,
  });

  final String text, title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        GestureDetector(
          onTap: onTap,
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFFC40123),
            ),
          ),
        )
      ],
    );
  }
}
