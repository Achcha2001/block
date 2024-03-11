import 'package:flutter/material.dart';

class LoginButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor; // Add buttonColor property

  const LoginButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.buttonColor, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50), backgroundColor: buttonColor, // Set the background color
      ),
    );
  }
}
