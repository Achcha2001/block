// reservation_model.dart

import 'package:flutter/material.dart';

class Reservation {
  late String telebooth;
  late DateTime date;
  late TimeOfDay time;
  late int duration;
  late String user;

  Reservation(
    this.telebooth,
    this.date,
    this.time,
    this.duration,
    this.user,
  );

  // Convert the reservation to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'telebooth': telebooth,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'duration': duration,
      'user': user,
    };
  }

  // Create a reservation from a map retrieved from Firebase
  Reservation.fromMap(Map<String, dynamic> map)
      : telebooth = map['telebooth'],
        date = DateTime.parse(map['date']),
        time = _parseTime(map['time']),
        duration = map['duration'],
        user = map['user'];

  // Helper method to parse time from string
  static TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
