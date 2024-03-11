import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'firebase_auth_service.dart';
import 'text_field_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuthService _authService = FirebaseAuthService();
  File? _image;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      user = _auth.currentUser;

      User? updatedUser = await _authService.getUserDetails(user?.uid);

      setState(() {
        _fullNameController.text = updatedUser?.displayName ?? '';
        _emailController.text = updatedUser?.email ?? '';
        _passwordController.text = ''; // Set password field to an empty string or placeholder
        // You can fetch and set other fields as needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 18, 31, 93),
      ),
      backgroundColor: Color.fromARGB(164, 18, 31, 93),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _image != null
                          ? (FileImage(_image!) as ImageProvider<Object>)
                          : AssetImage('assets/default_avatar.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: _pickImageFromCamera,
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFieldWidget(
                label: 'Full Name',
                controller: _fullNameController,
              ),
              SizedBox(height: 10),
              TextFieldWidget(
                label: 'Email',
                controller: _emailController,
              ),
              SizedBox(height: 10),
              TextFieldWidget(
                label: 'Password',
                isPassword: true,
                controller: _passwordController,
              ),
              SizedBox(height: 10),
              TextFieldWidget(
                label: 'Confirm Password',
                isPassword: true,
                controller: _confirmPasswordController,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _updateProfile();
                  await _uploadImageToFirebaseStorage();
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await user.updateProfile(displayName: _fullNameController.text);

        // If updating email and password is needed, use the following:
        await user.updateEmail(_emailController.text);
        await user.updatePassword(_passwordController.text);

        print('Profile updated successfully');
        _showSuccessAlert();
        _clearFields();
      } catch (e) {
        print('Failed to update profile: $e');
        // Handle the error here
      }
    }
  }

  Future<void> _uploadImageToFirebaseStorage() async {
    if (_image != null) {
      try {
        final Reference storageReference =
            FirebaseStorage.instance.ref().child('profile_images/${_auth.currentUser?.uid}.jpg');

        await storageReference.putFile(_image!);
        print('Image uploaded to Firebase Storage');
      } catch (e) {
        print('Failed to upload image: $e');
        // Handle the error here
      }
    }
  }

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Profile updated successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _clearFields() {
    setState(() {
      _fullNameController.text = '';
      _emailController.text = '';
      _passwordController.text = '';
      _confirmPasswordController.text = '';
    });
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }
}
