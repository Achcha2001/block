import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'text_field_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 31, 93),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              child: Image.asset('assets/ai_block_logo.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            TextFieldWidget(
              label: 'Username or Email',
              controller: _emailController,
            ),
            SizedBox(height: 10),
            TextFieldWidget(
              label: 'Password',
              isPassword: true,
              controller: _passwordController,
            ),
            SizedBox(height: 20),
            Container(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  // Check if the email contains the 'acumen' domain
                  if (!email.contains('acumen')) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Invalid Domain'),
                        content: Text('You are not a part of our company!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the alert
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                    return; // Stop further execution
                  }

                  try {
                    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Navigate to the home page on successful login
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } catch (e) {
                    // Handle login errors
                    print('Login failed: $e');

                    // Show alert for incorrect credentials
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Login Failed'),
                        content: Text('Invalid email or password. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the alert
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
