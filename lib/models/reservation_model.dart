import 'package:flutter/material.dart';

class ReservationModel {
  String id; 
  String userId; // User ID associated with the reservation
  DateTime date; // Date of the reservation
  TimeOfDay time; // Time of the reservation
  int numberOfPersons; // Number of persons for the reservation
  String notes; // Any additional notes
  String status;

  // Constructor
  ReservationModel({
    required this.id,
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
      'id' : id,
      'userId': userId,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}', // Store time as a string
      'numberOfPersons': numberOfPersons,
      'notes': notes,
      'status':status,
    };
  }

  // Create a ReservationModel from a Map (for retrieving from databases)
  factory ReservationModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ReservationModel(
      id: map['id'],
      userId: map['userId'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      time: TimeOfDay(
        hour: map['time'] != null ? int.parse(map['time'].split(':')[0]) : 0,
        minute: map['time'] != null ? int.parse(map['time'].split(':')[1]) : 0,
      ),
      numberOfPersons: map['numberOfPersons'] ?? 0,
      notes: map['notes'] ?? '',
      status: map['status'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ReservationModel(id: $id, userId: $userId, date: $date, time: $time, numberOfPersons: $numberOfPersons, notes: $notes,status: $status)';
  }
}
