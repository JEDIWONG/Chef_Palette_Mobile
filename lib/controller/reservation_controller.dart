// ignore_for_file: avoid_print
import 'package:chef_palette/models/reservation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ReservationController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new reservation to the "reservations" collection
  Future<void> addReservation(ReservationModel reservation) async {
    try {
      DocumentReference docRef = await _firestore.collection('reservations').add(reservation.toMap());
      await docRef.update({'id':docRef.id});
      print("Reservation added successfully!");
    } catch (e) {
      print("Failed to add reservation: $e");
    }
  }

  // Update an existing reservation in the "reservations" collection
  Future<void> updateReservation(String id, ReservationModel updatedReservation) async {
    try {
      await _firestore
          .collection('reservations')
          .doc(id)
          .update(updatedReservation.toMap());
      print("Reservation updated successfully!");
    } catch (e) {
      print("Failed to update reservation: $e");
    }
  }

  // Delete a reservation from the "reservations" collection
  Future<void> deleteReservation(String id) async {
    try {
      await _firestore.collection('reservations').doc(id).delete();
      print("Reservation deleted successfully!");
    } catch (e) {
      print("Failed to delete reservation: $e");
    }
  }

  // Fetch all reservations from the "reservations" collection
  Future<List<ReservationModel>> getAllReservations() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('reservations').get();
      return snapshot.docs.map((doc) {
        debugPrint(doc.id); //yea doc id does exist
        return ReservationModel.fromMap({
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id, // Include the document ID
        });
      }).toList();
    } catch (e) {
      print("Failed to fetch reservations: $e");
      return [];
    }
  }

  // Fetch a single reservation by its ID
  Future<ReservationModel?> getReservationById(String id) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('reservations').doc(id).get();
      if (snapshot.exists) {
        debugPrint(" id: ${snapshot.id}");
        return ReservationModel.fromMap({
          ...snapshot.data() as Map<String, dynamic>,
          'id': snapshot.id,
        });
      }
      return null;
    } catch (e) {
      print("Failed to fetch reservation: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getReservationsByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        debugPrint("List of reservation ID requested by user: ${doc.id}");
        // Include the Firestore document ID in the Map
        return {
          'id': doc.id, // Firestore document ID
          'reservation': ReservationModel(
            id: doc.id,
            userId: data['userId'] ?? '',
            date: DateTime.parse(data['date']),
            time: TimeOfDay(
              hour: int.parse(data['time'].split(':')[0]),
              minute: int.parse(data['time'].split(':')[1]),
            ),
            numberOfPersons: data['numberOfPersons'] ?? 0,
            notes: data['notes'] ?? '',
            status: data['status'] ?? 'Unknown',
          ),
        };
      }).toList();
    } catch (e) {
      print("Failed to fetch reservations for user $userId: $e");
      return [];
    }
  }


}
