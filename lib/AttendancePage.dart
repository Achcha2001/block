import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_page.dart';

// Model class for Attendance data
class Attendance {
  late String fullName;
  late String date;
  late String time;
  late String note;
  late String userEmail; // Added userEmail property
  late DateTime timestamp; // Added timestamp property

  Attendance({
    required this.fullName,
    required this.date,
    required this.time,
    required this.note,
    required this.userEmail,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'date': date,
      'time': time,
      'note': note,
      'userEmail': userEmail,
      'timestamp': timestamp.toUtc().toIso8601String(), // Convert to UTC and format as ISO8601 string
    };
  }

  factory Attendance.fromMap(Map<dynamic, dynamic> map) {
    return Attendance(
      fullName: map['fullName'],
      date: map['date'],
      time: map['time'],
      note: map['note'],
      userEmail: map['userEmail'],
      timestamp: DateTime.parse(map['timestamp']), // Parse the ISO8601 string back to DateTime
    );
  }
}


class AttendancePage extends StatefulWidget {
  final String fullName; // Add this line to receive the fullName parameter

  const AttendancePage({Key? key, required this.fullName}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime? _selectedDate;
  String? _selectedTime;
  int _currentIndex = 0;
  late PageController _pageController;
  DatabaseReference _attendanceRef =
      FirebaseDatabase.instance.reference().child('attendance');
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2023),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked.format(context);
      });
    }
  }

  Future<void> _selectTomorrow(BuildContext context) async {
    final DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    setState(() {
      _selectedDate = tomorrow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notify Attendance',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(164, 18, 31, 93),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color.fromARGB(164, 18, 31, 93),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildPage('Notify Your Attendance'),
          _buildPage('Profile Content'),
          _buildPage('Notifications Content'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 18, 31, 93),
        selectedItemColor: Colors.white.withOpacity(0.6),
        unselectedItemColor: Colors.white.withOpacity(0.6),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          });

          // Navigate to Home Page when Home icon is tapped
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String pageTitle) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            pageTitle,
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _selectDate(context),
            icon: Icon(Icons.calendar_today, color: Colors.black),
            label: Text('Select Date'),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                // Set the selected date to the current date
                _selectedDate = DateTime.now();
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            icon: Icon(Icons.today, color: Colors.white),
            label: Text(
              'Today - ${_formatDate(DateTime.now())}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => _selectTomorrow(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            icon: Icon(Icons.calendar_today, color: Colors.white),
            label: Text(
              'Tomorrow - ${_formatDate(DateTime.now().add(Duration(days: 1)))}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          if (_selectedDate != null)
            Text(
              'Selected Date: ${_selectedDate!.toLocal()}',
              style: TextStyle(color: Colors.white),
            ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _selectTime(context),
            icon: Icon(Icons.access_time, color: Colors.white),
            label: Text('Select Time', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          ),
          SizedBox(height: 10),
          if (_selectedTime != null)
            Text(
              'Selected Time: $_selectedTime',
              style: TextStyle(color: Colors.white),
            ),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Note',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Handle Confirm Button Press
              _confirmAttendance(widget.fullName); // Pass fullName parameter
            },
            icon: Icon(Icons.check, color: Colors.white),
            label: Text('Confirm', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  void _confirmAttendance(String fullName) {
    if (_selectedDate != null && _selectedTime != null) {
      _auth.authStateChanges().listen((User? user) {
        if (user != null) {
          Attendance attendance = Attendance(
            fullName: fullName,
            date: _formatDate(_selectedDate!),
            time: _selectedTime!,
            note: 'Note Value', // Replace with the actual note value
            userEmail: user.email!,
            timestamp: DateTime.now() // Get the user's email
          );

          _attendanceRef.push().set(attendance.toMap()).then((_) {
            // Data successfully pushed to the database
            _showSuccessAlert();
          }).catchError((error) {
            // Handle error, show error alert, or log
            print("Error: $error");
          });
        }
      });
    }
  }

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Attendance confirmed successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
