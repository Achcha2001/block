import 'package:flutter/material.dart';

class PoweredByText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 85),
      child: Column(
        children: [
          Text(
            'Powered by',
            style: TextStyle(
              fontSize: 16,
              
              color: Colors.white,
            ),
          ),
          // Add more widgets related to PoweredByText if needed
        ],
      ),
    );
  }
}
