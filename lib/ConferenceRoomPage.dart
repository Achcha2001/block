import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MaterialApp(
    home: ConferenceRoomPage(),
  ));
}

class ConferenceRoomPage extends StatefulWidget {
  @override
  _ConferenceRoomPageState createState() => _ConferenceRoomPageState();
}

class _ConferenceRoomPageState extends State<ConferenceRoomPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Duration? _selectedDuration;
  Color buttonColor = Colors.grey;

  DatabaseReference _reservationsRef =
      FirebaseDatabase.instance.reference().child('reservations');

  List<Map<String, dynamic>> reservedRooms = [];

  @override
  void initState() {
    super.initState();
    fetchReservedRooms();
  }

  void fetchReservedRooms() {
    _reservationsRef.onValue.listen((event) {
      reservedRooms.clear();
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? reservationsData =
            event.snapshot.value as Map<dynamic, dynamic>?;

        if (reservationsData != null) {
          reservationsData.forEach((key, value) {
            reservedRooms.add({
              'userEmail': value['userEmail'],
              'date': value['date'],
              'time': value['time'],
              'duration': value['duration'],
            });
          });
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reserve Conference Room',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 18, 31, 93),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 18, 31, 93),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDate = DateTime.now();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      backgroundColor: buttonColor,
                      minimumSize: Size(300, 100),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Conference Room',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (_selectedDate != null)
                          Text(
                            '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = DateTime.now();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.black,
                          minimumSize: Size(100, 50),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Today',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            if (_selectedDate != null)
                              Text(
                                '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate =
                                DateTime.now().add(Duration(days: 1));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.black,
                          minimumSize: Size(100, 50),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Tomorrow',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            if (_selectedDate != null)
                              Text(
                                '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text(
                      'Select a Time',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      minimumSize: Size(200, 50),
                      backgroundColor: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_selectedTime != null)
                    Text(
                      'Selected Time: ${_selectedTime!.format(context)}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  SizedBox(height: 10),
                  DropdownButton<Duration>(
                    hint: Text(
                      'Select Duration',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _selectedDuration,
                    onChanged: (Duration? newValue) {
                      setState(() {
                        _selectedDuration = newValue;
                      });
                    },
                    items: [
                      Duration(minutes: 30),
                      Duration(hours: 1),
                      Duration(hours: 2),
                    ]
                        .map(
                          (duration) => DropdownMenuItem<Duration>(
                            value: duration,
                            child: Text('${duration.inMinutes} minutes'),
                          ),
                        )
                        .toList(),
                    dropdownColor: Colors.black,
                    icon: Icon(Icons.calendar_today, color: Colors.white),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  if (_selectedDuration != null)
                    Text(
                      'Selected Duration: ${_selectedDuration!.inMinutes} minutes',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _handleConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
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
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _cancelReservation,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.red,
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Cancel Reservation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Reserved Conference Rooms',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildReservedRoomsList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
Widget _buildReservedRoomsList() {
  List<Map<String, dynamic>> reversedRooms = List.from(reservedRooms.reversed);

  return reversedRooms.isEmpty
      ? Text(
          'No reservations yet',
          style: TextStyle(color: Colors.white),
        )
      : ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: reversedRooms.map((room) {
            return Dismissible(
              key: Key(room.toString()), // Unique key for each item
              onDismissed: (direction) {
                // Remove the item from the data source when dismissed
                setState(() {
                  reservedRooms.remove(room);
                });
              },
              background: Container(
                color: Colors.red, // Background color when swiping
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    'User: ${room['userEmail'] ?? ''} - Date: ${room['date'] ?? ''} - Time: ${room['time'] ?? ''} - Duration: ${room['duration'] ?? ''}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );
          }).toList(),
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

        if ((_selectedDate?.weekday == DateTime.monday &&
                _selectedTime!.hour == 15 &&
                _selectedTime!.minute == 0) ||
            (_selectedDate?.weekday == DateTime.wednesday &&
                _selectedTime!.hour == 14 &&
                _selectedTime!.minute == 0)) {
          _selectedTime = null;
          _showAlert(
              'Booking not allowed for this time slot on the selected day.');
        } else {
          buttonColor = Colors.black;
        }
      });
    }
  }

  void _cancelReservation() {
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
      _selectedDuration = null;
      buttonColor = Colors.grey;
    });
  }

  void _handleConfirm() {
    if (_selectedDate != null &&
        _selectedTime != null &&
        _selectedDuration != null) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        Map<String, dynamic> reservationData = {
          'userEmail': user.email,
          'date': '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
          'time': _selectedTime!.format(context),
          'duration': '${_selectedDuration!.inMinutes} minutes',
        };

        _reservationsRef.push().set(reservationData);
        _cancelReservation();
        _showAlert('Reservation confirmed successfully!');
      } else {
        _showAlert('User not authenticated.');
      }
    } else {
      _showAlert('Please select date, time, and duration.');
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
