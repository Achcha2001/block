import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'models/seat_reservation.dart';

class ReserveWorkstationPage extends StatefulWidget {
  @override
  _ReserveWorkstationPageState createState() => _ReserveWorkstationPageState();
}

class _ReserveWorkstationPageState extends State<ReserveWorkstationPage> {
  List<SeatReservation> reservations = [];
  String? selectedChair;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<DateTime> dateOptions = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
  ];

  DatabaseReference _reservationsRef =
      FirebaseDatabase.instance.reference().child('workstation_reservation');

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  void _fetchReservations() {
    _reservationsRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        List<dynamic>? values = event.snapshot.value as List<dynamic>?;

        if (values != null) {
          List<SeatReservation> retrievedReservations = [];

          values.forEach((value) {
            SeatReservation reservation = SeatReservation.fromMap(value);
            retrievedReservations.add(reservation);
          });

          setState(() {
            reservations = retrievedReservations;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reserve Workstation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 18, 31, 93),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue.shade900,
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
                  if (selectedChair != null)
                    Text(
                      'Selected Seat: $selectedChair',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  SizedBox(height: 20),
                  _buildTable('Kingdom'),
                  SizedBox(height: 20),
                  _buildTable('Sakura'),
                  SizedBox(height: 20),
                  _buildTable('Bali'),
                  SizedBox(height: 20),
                  _buildTable('Lion Head'),
                  SizedBox(height: 20),
                  // Display reserved seats below the Confirm button
                  _buildReservedSeatsDetails(),
                  DropdownButton<DateTime>(
                    hint: Text('Select a Date'),
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
                    icon: Icon(Icons.calendar_today, color: Colors.white),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50),
                      backgroundColor: Colors.black,
                    ),
                    child: Text('Select a Time'),
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
                  ElevatedButton(
                    onPressed: () {
                      _handleConfirm();
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

  Widget _buildTable(String tableName) {
    return Column(
      children: [
        Text(
          tableName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(4, (index) {
              return _buildChairButton(tableName, index + 1);
            }),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(4, (index) {
              return _buildChairButton(tableName, index + 5);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildChairButton(String tableName, int chairNumber) {
    bool isChairSelected = selectedChair == '$tableName-$chairNumber';
    bool isReserved = _isSeatReserved('$tableName-$chairNumber');
    bool isSelectedDate = _selectedDate != null && _selectedTime != null;

    return ElevatedButton(
      onPressed: () {
        if (isSelectedDate) {
          if (!isReserved) {
            setState(() {
              selectedChair =
                  isChairSelected ? null : '$tableName-$chairNumber';
            });
          } else {
            _showAlert('This seat is already reserved.');
          }
        } else {
          _showAlert('Please select a date and time first.');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _getChairBackgroundColor(isSelectedDate, isReserved, isChairSelected),
        minimumSize: Size(30, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        '${tableName[0]}$chairNumber',
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  Color _getChairBackgroundColor(bool isSelectedDate, bool isReserved, bool isChairSelected) {
    if (isSelectedDate && isReserved) {
      return Colors.black; // Set color to black for reserved seats
    } else {
      return isChairSelected ? Colors.black : Colors.grey;
    }
  }

  Widget _buildReservedSeatsDetails() {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          'Reserved Seats Details:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        _buildReservationDetailsList(),
      ],
    );
  }

  Widget _buildReservationDetailsList() {
    return reservations.isEmpty
        ? Text(
            'No reservations',
            style: TextStyle(color: Colors.white),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              SeatReservation reservation = reservations[index];
              return Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    'User: ${reservation.email}, Seat: ${reservation.seat}, Date and Time: ${reservation.date} ${reservation.time}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          );
  }

  bool _isSeatReserved(String seat) {
    return reservations.any((reservation) =>
        reservation.seat == seat &&
        reservation.date == _formatDate(_selectedDate!));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _handleConfirm() async {
    if (_selectedDate != null &&
        _selectedTime != null &&
        selectedChair != null) {
      if (_isSeatReserved(selectedChair!)) {
        _showAlert('This seat is already booked on the selected date.');
      } else {
        User? user = _auth.currentUser;

        if (user != null) {
          await user.reload();
          user = _auth.currentUser;

          if (user != null) {
            SeatReservation reservation = SeatReservation(
              userId: user.uid,
              email: user.email!,
              date:
                  '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',
              time: _selectedTime!.format(context),
              seat: selectedChair!,
            );

            _reservationsRef.push().set(reservation.toMap());

            _showAlert('Reservation confirmed successfully!');
            _resetSelections();
          } else {
            _showAlert(
                'User information not available. Please log in again.');
          }
        } else {
          _showAlert('User not authenticated. Please log in.');
        }
      }
    } else {
      _showAlert('Please select date, time, and seat.');
    }
  }

  void _resetSelections() {
    setState(() {
      selectedChair = null;
      _selectedDate = null;
      _selectedTime = null;
    });
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

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}

void main() {
  runApp(MaterialApp(
    home: ReserveWorkstationPage(),
  ));
}
