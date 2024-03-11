import 'package:block/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_button_widget.dart';
import 'firebase_auth_service.dart';
import 'home_page.dart'; // Import the home page
import 'login_page.dart'; // Import the login page

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 31, 93),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: Image.asset('assets/ai_block_logo.png'),
              ),
              SizedBox(height: 20),
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              TextFieldWidget(label: 'Full Name', controller: _fullNameController),
              SizedBox(height: 10),
              TextFieldWidget(label: 'Email', controller: _emailController),
              SizedBox(height: 10),
              TextFieldWidget(label: 'Password', isPassword: true, controller: _passwordController),
              SizedBox(height: 10),
              TextFieldWidget(
                label: 'Confirm Password',
                isPassword: true,
                controller: _confirmPasswordController,
              ),
              SizedBox(height: 20),
              Container(
                width: buttonWidth,
                child: LoginButtonWidget(
                  onPressed: () async {
                    String fullName = _fullNameController.text;
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    User? user = await _authService.registerWithEmailAndPassword(email, password);

                    if (user != null) {
                      // Registration successful
                      print('Registration successful');

                      // Navigate to the home page with full name
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    } else {
                      // Registration failed, handle error or show a message
                      print('Registration failed');
                    }
                  },
                  text: 'LETS GET STARTED',
                  buttonColor: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navigate back to the login page
                  Navigator.pop(context);
                },
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
