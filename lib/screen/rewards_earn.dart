import 'package:flutter/material.dart';
import 'package:chef_palette/models/reward_model.dart';
import 'package:chef_palette/models/user_reward_model.dart';

class RewardsEarn extends StatelessWidget {
  final UserRewardModel userReward;
  final List<RewardModel> allRewards; // List of all rewards for matching

  const RewardsEarn({
    super.key,
    required this.userReward,
    required this.allRewards,
  });

  @override
  Widget build(BuildContext context) {
    // Filter redeemed rewards
    final redeemedRewards = allRewards.where((reward) {
      return userReward.redeemedRewards.contains(reward.id);
    }).toList();

    return redeemedRewards.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "You haven't redeemed any rewards yet.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Redeemed Rewards",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                ...redeemedRewards.map((reward) => RedeemedRewardCard(reward: reward)),

                
              ],

              
            ),
          );
  }
}

class RedeemedRewardCard extends StatelessWidget {
  final RewardModel reward;

  const RedeemedRewardCard({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reward Title
          Text(
            reward.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 10),

          // Reward Description
          Text(
            reward.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Points Required or Redeemed
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    "${reward.pointsRequired} Points",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Chip(
                label: const Text(
                  "Redeemed",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
