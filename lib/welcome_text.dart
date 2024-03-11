import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 45),
      child: Column(
        children: [
          Text(
            'Welcome to the',
            style: TextStyle(
              fontSize: 36,
              color: Colors.white,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'AI',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set the font color to white
                  ),
                ),
                TextSpan(
                  text: 'BLOCK',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey, // Set the font color to gray
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
