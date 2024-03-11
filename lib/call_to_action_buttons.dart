import 'package:flutter/material.dart';

import 'RegisterPage.dart'; // Import the RegisterPage
import 'login_page.dart';

class CallToActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Container(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the login page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Set the background color to black
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Set the border radius
                    ),
                  ),
                 child: Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 5), // Adjust the height between buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the register page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set the background color to black
                   shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Set the border radius
                    ),
                ),
            child: Text(
                  'LETS GET STARTED',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Set the text color to white
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
