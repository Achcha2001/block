import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AttendancePage.dart';
import 'ConferenceRoomPage.dart';
import 'NotificationPage.dart';
import 'OverviewPage.dart';
import 'ReserveWorkstationPage.dart';
import 'profilepage.dart';
import 'teleboothpage.dart';
import 'MassageChairPage.dart';

class LargeButtonWidget extends StatelessWidget {
  final List<String> texts;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color backgroundColor;

  const LargeButtonWidget({
    Key? key,
    required this.texts,
    required this.onPressed,
    required this.width,
    required this.height,
    this.backgroundColor = const Color.fromARGB(204, 18, 31, 93),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        minimumSize: Size(width, height),
      ),
      child: Container(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                texts[0],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                texts[1],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  void fetchUserEmail() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      setState(() {
        userEmail = user.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 18, 31, 93),
        title: Text(
          'HOME',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 18, 31, 93),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 34,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      userEmail, // Display user email here
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 120,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LargeButtonWidget(
                          texts: ['Notify', 'Attendance'],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendancePage(fullName: ''),
                              ),
                            );
                          },
                          width: 130,
                          height: 110,
                        ),
                        LargeButtonWidget(
                          texts: ['Reserve', 'Workstation'],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReserveWorkstationPage(),
                              ),
                            );
                          },
                          width: 130,
                          height: 110,
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LargeButtonWidget(
                          texts: ['Reserve ', 'Telebooth'],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeleboothReservationPage(),
                              ),
                            );
                          },
                          width: 130,
                          height: 110,
                        ),
                        LargeButtonWidget(
                          texts: ['Conference', 'Room'],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConferenceRoomPage(),
                              ),
                            );
                          },
                          width: 130,
                          height: 110,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LargeButtonWidget(
                          texts: ['Overview', 'of the office'],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OverviewPage(),
                              ),
                            );
                          },
                          width: 310,
                          height: 100,
                          backgroundColor: Colors.black.withOpacity(0.8),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LargeButtonWidget(
                          texts: ['Massage', 'Chair'],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MassageChairPage(),
                              ),
                            );
                          },
                          width: 310,
                          height: 100,
                          backgroundColor: Colors.black.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 18, 31, 93),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Handle navigation based on index
          if (index == 0) {
            // Navigate to Home Page
          } else if (index == 1) {
            // Navigate to Profile Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationPage()),
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
}
