import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lib/shared/constants.dart'; // Import the Constants class from your package
import 'landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDiG9Tgq_4Z2f03WvLAnxi3rQm9_PLyESc",
  authDomain: "block-3e66c.firebaseapp.com",
        appId: "1:341834859651:web:1b86a16e50fa52adaf47b6",
        databaseURL: "https://block-3e66c-default-rtdb.firebaseio.com",
        messagingSenderId: "341834859651",
        projectId: "fir-project-a0028",
        storageBucket: "fir-project-a0028.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
