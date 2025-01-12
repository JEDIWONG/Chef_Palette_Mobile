import 'package:chef_palette/models/reward_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 
class RewardController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String rewardsCollection = 'rewards'; // Firestore collection name

  // Create a new reward
  Future<void> createReward(RewardModel reward) async {
    try {
      DocumentReference docRef =
          _firestore.collection(rewardsCollection).doc(reward.id);

      await docRef.set(reward.toMap());
      print('Reward created successfully: ${reward.id}');
    } catch (e) {
      print('Error creating reward: $e');
      rethrow;
    }
  }

  // Update an existing reward
  Future<void> updateReward(String id, Map<String, dynamic> updates) async {
    try {
      DocumentReference docRef =
          _firestore.collection(rewardsCollection).doc(id);

      await docRef.update(updates);
      print('Reward updated successfully: $id');
    } catch (e) {
      print('Error updating reward: $e');
      rethrow;
    }
  }

  // Delete a reward
  Future<void> deleteReward(String id) async {
    try {
      DocumentReference docRef =
          _firestore.collection(rewardsCollection).doc(id);

      await docRef.delete();
      print('Reward deleted successfully: $id');
    } catch (e) {
      print('Error deleting reward: $e');
      rethrow;
    }
  }

  // Get a reward by ID
  Future<RewardModel?> getRewardById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(rewardsCollection).doc(id).get();

      if (doc.exists) {
        return RewardModel.fromMap({
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        });
      } else {
        print('Reward not found: $id');
        return null;
      }
    } catch (e) {
      print('Error fetching reward: $e');
      rethrow;
    }
  }

  // Get all rewards
  Future<List<RewardModel>> getAllRewards() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(rewardsCollection).get();

      return querySnapshot.docs.map((doc) {
        return RewardModel.fromMap({
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        });
      }).toList();
    } catch (e) {
      print('Error fetching rewards: $e');
      rethrow;
    }
  }
}
