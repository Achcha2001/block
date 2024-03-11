import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;

  const TextFieldWidget({
    Key? key,
    required this.label,
    this.isPassword = false,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double textFieldWidth = screenWidth * 0.8;

    return Container(
      width: textFieldWidth,
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white), // Set text color to white
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white), // Set label text color to white
          border: OutlineInputBorder(),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(Icons.visibility_off),
                  onPressed: () {},
                )
              : null,
        ),
        obscureText: isPassword,
      ),
    );
  }
}
