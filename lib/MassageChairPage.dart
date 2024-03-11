import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

class MassageChair {
  String? key;
  String name;
  String date;
  String time;
  int duration; // Duration in minutes

  MassageChair(this.name, this.date, this.time, this.duration);

  factory MassageChair.fromSnapshot(DataSnapshot snapshot) {
    String getString(String key) {
      return snapshot.value != null &&
              snapshot.value is Map<String, dynamic> &&
              (snapshot.value as Map<String, dynamic>).containsKey(key)
          ? (snapshot.value as Map<String, dynamic>)[key].toString()
          : '';
    }

    int getInt(String key) {
      return snapshot.value != null &&
              snapshot.value is Map<String, dynamic> &&
              (snapshot.value as Map<String, dynamic>).containsKey(key)
          ? (snapshot.value as Map<String, dynamic>)[key] as int
          : 0;
    }

    return MassageChair(
      getString('name'),
      getString('date'),
      getString('time'),
      getInt('duration'),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date,
        'time': time,
        'duration': duration,
      };
}

class MassageChairPage extends StatefulWidget {
  @override
  _MassageChairPageState createState() => _MassageChairPageState();
}

class _MassageChairPageState extends State<MassageChairPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late DatabaseReference _database;
  List<MassageChair> reservations = [];
  List<MassageChair> massageChairNotifications = []; // Added this line

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController nameController = TextEditingController();
  int selectedDuration = 30; // Default duration in minutes

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
    _database = FirebaseDatabase.instance.reference().child('massage_chairs');

    // Add an event listener to update reservations when data changes
    _database.onChildAdded.listen((event) {
      setState(() {
        reservations.add(MassageChair.fromSnapshot(event.snapshot));
      });
    });

    // Fetch initial reservations
    _fetchMassageChairReservations();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _reserveMassageChair() {
    if (nameController.text.isNotEmpty) {
      setState(() {
        MassageChair reservation = MassageChair(
          nameController.text,
          "${selectedDate.toLocal()}".split(' ')[0],
          selectedTime.format(context),
          selectedDuration,
        );

        // Push reservation data to the Realtime Database
        _database.push().set(reservation.toJson());

        // Clear the text field after reservation
        nameController.clear();
      });
    }
  }

  Future<void> _fetchMassageChairReservations() async {
  try {
    DatabaseReference chairRef = _database.child('massage_chairs');
    DatabaseEvent snapshot = await chairRef.once();

    if (snapshot.snapshot.value != null) {
      Map<dynamic, dynamic>? chairData =
          snapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (chairData != null) {
        List<Map<String, dynamic>> notifications = chairData.values
            .where((chair) => chair['timestamp'] != null)
            .where((chair) {
              DateTime notificationTime = DateTime.parse(chair['timestamp']);
              DateTime twentyFourHoursAgo =
                  DateTime.now().subtract(Duration(hours: 24));
              return notificationTime.isAfter(twentyFourHoursAgo);
            })
            .map((chair) {
              return {
                'notification':
                    '${chair['name']} reserved a chair for ${chair['duration']} min on ${chair['date']} at ${chair['time']}.',
                 // You can add email logic if available in your data
                'timestamp': chair['timestamp'],
              };
            })
            .toList();

        setState(() {
          massageChairNotifications = notifications.cast<MassageChair>();
        });
      }
    }
  } catch (error) {
    print('Error fetching massage chair reservations: $error');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Massage Chair Reservation'),
      ),
      body: Container(
        color: Color.fromARGB(255, 18, 31, 93),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fade-in Animation for the 3D model placeholder
                FadeTransition(
                  opacity: _opacity,
                  child: Container(
                    height: 200, // Adjust the height accordingly
                    color: Colors.grey,
                    child: Center(
                      child: Icon(
                        Icons.chair,
                        size: 80,
                        color: Colors.blue, // Customize the icon color
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Date Picker
                Text(
                  'Select Date:',
                  style: TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                ),

                SizedBox(height: 20),

                // Time Picker
                Text(
                  'Select Time:',
                  style: TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text(selectedTime.format(context)),
                ),

                SizedBox(height: 20),

                // Duration Picker
                Text(
                  'Select Duration:',
                  style: TextStyle(color: Colors.white),
                ),
                DropdownButton<int>(
                  value: selectedDuration,
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        selectedDuration = value;
                      });
                    }
                  },
                  items: [30, 60, 90] // Adjust the duration options as needed
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(
                        '$value minutes',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 20),

                // Name input field
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                  ),
                ),

                SizedBox(height: 20),

                // Reserve Button
                ElevatedButton(
                  onPressed: () {
                    _reserveMassageChair();
                    _fetchMassageChairReservations(); // Fetch and update reservations after reserving
                  },
                  child: Text('Reserve Massage Chair'),
                ),

                SizedBox(height: 20),

                // Display reservations in a notification-style format
                Column(
                  children: reservations.map((chair) {
                    return ListTile(
                      title: Text(
                        '${chair.name} reserved a chair for ${chair.duration} min on ${chair.date} at ${chair.time}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
