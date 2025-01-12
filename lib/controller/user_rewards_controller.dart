// ignore_for_file: avoid_print
import 'package:chef_palette/models/user_reward_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRewardsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userRewardsCollection = 'user_rewards'; // Firestore collection name

  Future<UserRewardModel> getUserRewards(String userId) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          _firestore.collection(userRewardsCollection).doc(userId);

      DocumentSnapshot<Map<String, dynamic>> doc = await docRef.get();

      if (doc.exists) {
        // If the document exists, return the parsed UserRewardModel
        return UserRewardModel.fromMap({
          ...doc.data()!,
          'userId': doc.id,
        });
      } else {
        // If no document exists, create a default rewards document
        UserRewardModel defaultRewards = UserRewardModel(
          userId: userId,
          totalPoints: 0,
          totalPointsAccumulated: 0,
          tier: 'Bronze',
          redeemedRewards: [],
          lastUpdated: DateTime.now(),
        );

        // Save the default rewards document to Firestore
        await docRef.set(defaultRewards.toMap());
        print("Default rewards created for user: $userId");

        return defaultRewards;
      }
    } catch (e) {
      print("Error fetching or creating user rewards: $e");
      rethrow;
    }
  }


  // Update a user's rewards
  Future<void> updateUserRewards(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(userRewardsCollection).doc(userId).update(updates);
      print("User rewards updated successfully for user: $userId");
    } catch (e) {
      print("Error updating user rewards: $e");
      rethrow;
    }
  }

  // Add points to a user's total and accumulated points
  Future<void> addPoints(String userId, int points) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection(userRewardsCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        int currentPoints = doc.data()?['totalPoints'] ?? 0;
        int totalAccumulated = doc.data()?['totalPointsAccumulated'] ?? 0;

        await updateUserRewards(userId, {
          'totalPoints': currentPoints + points,
          'totalPointsAccumulated': totalAccumulated + points,
          'lastUpdated': DateTime.now().toIso8601String(),
        });

        print("Added $points points to user: $userId");
      } else {
        print("User not found: $userId");
      }
    } catch (e) {
      print("Error adding points: $e");
      rethrow;
    }
  }

  // Redeem a reward
  Future<void> redeemReward(String userId, String rewardId, int pointsRequired) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection(userRewardsCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        int currentPoints = doc.data()?['totalPoints'] ?? 0;

        if (currentPoints >= pointsRequired) {
          List<String> redeemedRewards = List<String>.from(doc.data()?['redeemedRewards'] ?? []);
          redeemedRewards.add(rewardId);

          await updateUserRewards(userId, {
            'totalPoints': currentPoints - pointsRequired,
            'redeemedRewards': redeemedRewards,
            'lastUpdated': DateTime.now().toIso8601String(),
          });

          print("Reward $rewardId redeemed successfully for user: $userId");
        } else {
          print("User $userId does not have enough points to redeem reward $rewardId");
        }
      } else {
        print("User not found: $userId");
      }
    } catch (e) {
      print("Error redeeming reward: $e");
      rethrow;
    }
  }

  // Reset user rewards (for example, for testing purposes)
  Future<void> resetUserRewards(String userId) async {
    try {
      await _firestore.collection(userRewardsCollection).doc(userId).set({
        'totalPoints': 0,
        'totalPointsAccumulated': 0,
        'tier': 'Bronze',
        'redeemedRewards': [],
        'lastUpdated': DateTime.now().toIso8601String(),
      });

      print("User rewards reset successfully for user: $userId");
    } catch (e) {
      print("Error resetting user rewards: $e");
      rethrow;
    }
  }
}
