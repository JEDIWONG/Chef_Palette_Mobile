// ignore_for_file: avoid_print

import 'package:chef_palette/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all users from Firebase Firestore
  Future<List<UserModel>> fetchUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').get();

      return snapshot.docs.map((doc) {
        return UserModel(
          uid: doc['uid'] ?? '',
          email: doc['email'] ?? '',
          firstName: doc['firstName'] ?? '',
          lastName: doc['lastName'] ?? '',
          phoneNumber: doc['phoneNumber'] ?? '',
          dob: doc['dob'] ?? '',
          joinDate: doc['joinDate'] ?? '',
          role: doc['role'] ?? '',
          branchLocation: doc['branchLocation'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  // Fetch a single user by their UID
  Future<UserModel?> fetchUserById(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(uid).get();

      if (snapshot.exists) {
        return UserModel(
          uid: snapshot['uid'] ?? '',
          email: snapshot['email'] ?? '',
          firstName: snapshot['firstName'] ?? '',
          lastName: snapshot['lastName'] ?? '',
          phoneNumber: snapshot['phoneNumber'] ?? '',
          dob: snapshot['dob'] ?? '',
          joinDate: snapshot['joinDate'] ?? '',
          role: snapshot['role'] ?? '',
          branchLocation: snapshot['branchLocation'] ?? '',
        );
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Add a new user to Firestore
  Future<void> addUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      print('User added successfully');
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  // Update an existing user in Firestore
  Future<void> updateUser(String uid, UserModel user) async {
    try {
      await _firestore.collection('users').doc(uid).update(user.toMap());
      print('User updated successfully');
    } catch (e) {
      print('Error updating user: $e');
    }
  }

    // Update only the branchLocation of an existing user in Firestore
  Future<void> updateUserBranchLocation(String uid, String branchLocation) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'branchLocation': branchLocation,
      });
      print('User branch location updated successfully');
    } catch (e) {
      print('Error updating branch location: $e');
    }
  }

  // Delete a user from Firestore
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      print('User deleted successfully');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}