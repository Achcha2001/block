import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/reservation_model.dart';

class TeleboothReservationPage extends StatefulWidget {
  @override
  _TeleboothReservationPageState createState() =>
      _TeleboothReservationPageState();
}

class _TeleboothReservationPageState
    extends State<TeleboothReservationPage> {
  int? _selectedTelebooth;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Duration? _selectedDuration;

  List<DateTime> dateOptions = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
  ];

  List<int> durationOptions = List.generate(61, (index) => index);

  final ScrollController _scrollController = ScrollController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Telebooth Reservation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 18, 31, 93),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: Color.fromARGB(255, 18, 31, 93),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  if (_selectedDate != null)
                    Text(
                      'Selected Date: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTelebooth('Telebooth 1', 1),
                      _buildTelebooth('Telebooth 2', 2),
                      // Add more telebooth buttons as needed
                    ],
                  ),
                  SizedBox(height: 20),
                  if (_selectedTelebooth != null)
                    Text(
                      'Selected Telebooth: Telebooth $_selectedTelebooth',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  SizedBox(height: 20),
                  DropdownButton<DateTime>(
                    hint: Text('Select a Date',
                        style: TextStyle(color: Colors.white)),
                    value: _selectedDate,
                    onChanged: (DateTime? newValue) {
                      setState(() {
                        _selectedDate = newValue;
                      });
                    },
                    items: dateOptions
                        .map((date) => DropdownMenuItem<DateTime>(
                              value: date,
                              child: Text(
                                '${date.day}-${date.month}-${date.year}',
                              ),
                            ))
                        .toList(),
                    dropdownColor: Colors.black,
                    icon: Icon(Icons.calendar_today,
                        color: Colors.white),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      backgroundColor: Colors.black,
                    ),
                    child: Text('Select a Time',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 10),
                  if (_selectedDate != null && _selectedTime != null)
                    Text(
                      'Selected Date and Time: ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year} ${_selectedTime!.format(context)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  SizedBox(height: 20),
                  DropdownButton<int>(
                    hint: Text('Select Duration (minutes)',
                        style: TextStyle(color: Colors.white)),
                    value: _selectedDuration?.inMinutes,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedDuration = Duration(minutes: newValue ?? 0);
                      });
                    },
                    items: durationOptions
                        .map((duration) => DropdownMenuItem<int>(
                              value: duration,
                              child: Text('$duration minutes'),
                            ))
                        .toList(),
                    dropdownColor: Colors.black,
                    icon: Icon(Icons.access_time, color: Colors.white),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _confirmReservation();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTelebooth(String teleboothName, int teleboothNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          _selectTelebooth(teleboothNumber);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedTelebooth == teleboothNumber
              ? Colors.black
              : null,
          minimumSize: Size(120, 280),
        ),
        child: Text(
          teleboothName,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _scrollToSelectedTelebooth();
      });
    }
  }

  void _selectTelebooth(int teleboothNumber) {
    setState(() {
      _selectedTelebooth = teleboothNumber;
    });
  }

  void _scrollToSelectedTelebooth() {
    if (_selectedTelebooth != null) {
      final double offset =
          _selectedTelebooth! * (280.0 + 16.0);
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _confirmReservation() async {
    if (_selectedDate != null &&
        _selectedTime != null &&
        _selectedTelebooth != null &&
        _selectedDuration != null) {
      DateTime selectedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Check for existing reservations on the selected date and time
      bool isReservationAvailable =
          await _checkReservationAvailability(selectedDateTime);

      if (isReservationAvailable) {
        // Perform the reservation save to Firebase or any other action
        _saveReservationToFirebase(selectedDateTime);

        // Show success alert
        _showSuccessAlert();
      } else {
        // Show alert for existing reservation
        _showExistingReservationAlert();
      }
    }
  }

  Future<bool> _checkReservationAvailability(DateTime selectedDateTime) async {
    // Replace this with your logic to check for existing reservations
    // For demonstration purposes, always return true for availability
    return true;
  }

 void _saveReservationToFirebase(DateTime selectedDateTime) async {
  User? user = _auth.currentUser;

  if (user != null) {
    try {
      // Access Realtime Database and save reservation data
      final databaseReference = FirebaseDatabase.instance.reference();
      await databaseReference.child('reservations').push().set({
        'userId': user.uid,
        'date': selectedDateTime.toIso8601String(),
        'telebooth': _selectedTelebooth,
        'duration': _selectedDuration?.inMinutes,
        // Add more fields as needed
      });

      print('Reservation saved to Realtime Database successfully.');
    } catch (e) {
      print('Error saving reservation to Realtime Database: $e');
      // Handle the error here
    }
  }
}

  void _showSuccessAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Reservation confirmed successfully!'),
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

  void _showExistingReservationAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('There is already a reservation for the selected date and time.'),
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
}

void main() {
  runApp(MaterialApp(
    home: TeleboothReservationPage(),
  ));
}
