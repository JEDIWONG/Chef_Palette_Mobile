// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/branch_model.dart';

class BranchController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all branches from Firebase Firestore
  Future<List<BranchModel>> fetchBranches() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('branchs').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return BranchModel(
          longitude: (data['longitude'] is String)
              ? double.tryParse(data['longitude']) ?? 0.0
              : data['longitude'] ?? 0.0,
          latitude: (data['latitude'] is String)
              ? double.tryParse(data['latitude']) ?? 0.0
              : data['latitude'] ?? 0.0,
          name: data['name'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching branches: $e');
      return [];
    }
  }

  // Fetch a single branch by its ID
  Future<BranchModel?> fetchBranchById(String branchId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('branchs').doc(branchId).get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        return BranchModel(
          longitude: (data['longitude'] is String)
              ? double.tryParse(data['longitude']) ?? 0.0
              : data['longitude'] ?? 0.0,
          latitude: (data['latitude'] is String)
              ? double.tryParse(data['latitude']) ?? 0.0
              : data['latitude'] ?? 0.0,
          name: data['name'] ?? '',
        );
      } else {
        print('Branch not found');
        return null;
      }
    } catch (e) {
      print('Error fetching branch: $e');
      return null;
    }
  }

  // Add a new branch to Firestore
  Future<void> addBranch(BranchModel branch) async {
    try {
      await _firestore.collection('branchs').add(branch.toMap());
      print('Branch added successfully');
    } catch (e) {
      print('Error adding branch: $e');
    }
  }

  // Update an existing branch in Firestore
  Future<void> updateBranch(String branchId, BranchModel branch) async {
    try {
      await _firestore.collection('branchs').doc(branchId).update(branch.toMap());
      print('Branch updated successfully');
    } catch (e) {
      print('Error updating branch: $e');
    }
  }

  // Delete a branch from Firestore
  Future<void> deleteBranch(String branchId) async {
    try {
      await _firestore.collection('branchs').doc(branchId).delete();
      print('Branch deleted successfully');
    } catch (e) {
      print('Error deleting branch: $e');
    }
  }
}
