import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'AttendancePage.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> attendanceNotifications = [];
  List<Map<String, dynamic>> reservationNotifications = [];
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchAttendanceNotifications();
    fetchReservationNotifications();
  }

  void fetchAttendanceNotifications() async {
    try {
      DatabaseReference attendanceRef = _databaseReference.child('attendance');
      // Use once().then() instead of await once()
      attendanceRef.once().then((DatabaseEvent snapshot) {
        print('Attendance Snapshot: ${snapshot.snapshot.value}');

        Map<dynamic, dynamic>? attendanceData =
            snapshot.snapshot.value as Map<dynamic, dynamic>?;

        if (attendanceData != null) {
          List<Map<String, dynamic>> notifications = attendanceData.values
              .where((attendance) {
                return attendance['timestamp'] != null;
              })
              .where((attendance) {
                DateTime notificationTime =
                    DateTime.parse(attendance['timestamp']);
                DateTime twentyFourHoursAgo =
                    DateTime.now().subtract(Duration(hours: 24));
                return notificationTime.isAfter(twentyFourHoursAgo);
              })
              .map((attendance) {
                return {
                  'notification':
                      ' marked attendance on ${attendance['date']} at ${attendance['time']}.',
                  'email': attendance['userEmail'],
                  'timestamp': attendance['timestamp'],
                };
              })
              .toList();

          setState(() {
            attendanceNotifications = notifications;
          });
        }
      });
    } catch (error) {
      print('Error fetching attendance notifications: $error');
    }
  }

  void fetchReservationNotifications() async {
    try {
      DatabaseReference reservationRef =
          _databaseReference.child('reservations');
      // Use once().then() instead of await once()
      reservationRef.once().then((DatabaseEvent snapshot) {
        if (snapshot.snapshot.value != null) {
          Map<dynamic, dynamic>? reservationData =
              snapshot.snapshot.value as Map<dynamic, dynamic>?;

          if (reservationData != null) {
            List<Map<String, dynamic>> notifications = reservationData.values
                .where((reservation) {
                  return reservation['timestamp'] != null;
                })
                .where((reservation) {
                  DateTime notificationTime =
                      DateTime.parse(reservation['timestamp']);
                  DateTime twentyFourHoursAgo =
                      DateTime.now().subtract(Duration(hours: 24));
                  return notificationTime.isAfter(twentyFourHoursAgo);
                })
                .map((reservation) {
                  return {
                    'notification':
                        '${reservation['userId']} made a reservation on ${reservation['date']} at Telebooth ${reservation['telebooth']} for ${reservation['duration']} minutes.',
                    'email': reservation['userEmail'] ?? '',
                    'timestamp': reservation['timestamp'],
                  };
                })
                .toList();

            setState(() {
              reservationNotifications = notifications;
            });
          }
        }
      });
    } catch (error) {
      print('Error fetching reservation notifications: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color.fromARGB(255, 18, 31, 93),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 18, 31, 93),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Attendance Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                _buildNotificationsList(attendanceNotifications),
                SizedBox(height: 16),
                Text(
                  'Reservation Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                _buildNotificationsList(reservationNotifications),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    notifications.sort((a, b) {
      DateTime timeA = DateTime.parse(a['timestamp']);
      DateTime timeB = DateTime.parse(b['timestamp']);
      return timeB.compareTo(timeA);
    });

    notifications = notifications.where((notification) {
      DateTime notificationTime = DateTime.parse(notification['timestamp']);
      DateTime twentyFourHoursAgo =
          DateTime.now().subtract(Duration(hours: 24));
      return notificationTime.isAfter(twentyFourHoursAgo);
    }).toList();

    return notifications.isEmpty
        ? Text(
            'No notifications',
            style: TextStyle(color: Colors.white),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notifications[index]['notification'] ?? '',
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'User Email: ${notifications[index]['email'] ?? ''}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationPage(),
  ));
}
