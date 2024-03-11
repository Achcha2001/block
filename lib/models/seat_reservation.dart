// models/seat_reservation.dart

class SeatReservation {
  String userId;
  String email;
  String date;
  String time;
  String seat;

  SeatReservation({
    required this.userId,
    required this.email,
    required this.date,
    required this.time,
    required this.seat,
  });

  // Convert SeatReservation to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'date': date,
      'time': time,
      'seat': seat,
    };
  }

  // Create SeatReservation from a map
  factory SeatReservation.fromMap(Map<String, dynamic> map) {
    return SeatReservation(
      userId: map['userId'],
      email: map['email'],
      date: map['date'],
      time: map['time'],
      seat: map['seat'],
    );
  }
}
