import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      print("User data saved successfully!");
    } catch (e) {
      print("Failed to save user data: $e");
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(uid).update(updates);
      print("User data updated successfully!");
    } catch (e) {
      print("Failed to update user data: $e");
    }
  }
}