import 'package:flutter/material.dart';

import 'call_to_action_buttons.dart';
import 'powered_by_text.dart';
import 'welcome_text.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Dark Blue Section (60%)
          Expanded(
            flex: 7, // 60% of the available height
            child: Container(
              color: Color.fromARGB(255, 18, 31, 93),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WelcomeText(),
                    SizedBox(height: 20),
                    PoweredByText(),
                    Container(
                      width: 270,
                      child: Image.asset('assets/ai_block_logo.png'),
                    ),
                    SizedBox(height: 18),
                    
                  ],
                ),
              ),
            ),
          ),
          // White Section (40%)
          Expanded(
            flex: 3, // 40% of the available height
            child: Container(
              color: Colors.white,
              child: CallToActionButtons(),
              // Add any widgets you want in the white section here
            ),
          ),
        ],
      ),
    );
  }
}
