import 'package:flutter/material.dart';

class ReservationModel {
  String userId; // User ID associated with the reservation
  DateTime date; // Date of the reservation
  TimeOfDay time; // Time of the reservation
  int numberOfPersons; // Number of persons for the reservation
  String notes; // Any additional notes
  String status;

  // Constructor
  ReservationModel({
    required this.userId,
    required this.date,
    required this.time,
    required this.numberOfPersons,
    required this.notes,
    required this.status,
  });

  // Convert ReservationModel to a Map (for storing in databases like Firebase)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}', // Store time as a string
      'numberOfPersons': numberOfPersons,
      'notes': notes,
      'status':status,
    };
  }

  // Create a ReservationModel from a Map (for retrieving from databases)
  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
      numberOfPersons: map['numberOfPersons'],
      notes: map['notes'],
      status: map['status'],
    );
  }

  @override
  String toString() {
    return 'ReservationModel(userId: $userId, date: $date, time: $time, numberOfPersons: $numberOfPersons, notes: $notes,status: $status)';
  }
}
