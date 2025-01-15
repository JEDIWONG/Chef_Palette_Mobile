import 'package:chef_palette/models/reward_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RewardSelectionScreen extends StatelessWidget {
  const RewardSelectionScreen({super.key});

  Future<List<RewardModel>> fetchRewards() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('rewards')
        .where('type', isEqualTo: 'Discount')
        .get();

    return snapshot.docs.map((doc) {
      return RewardModel.fromMap(doc.data());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Reward'),
      ),
      body: FutureBuilder<List<RewardModel>>(
        future: fetchRewards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching rewards'));
          }

          final rewards = snapshot.data ?? [];

          if (rewards.isEmpty) {
            return const Center(child: Text('No rewards available'));
          }

          return ListView.builder(
            itemCount: rewards.length + 1, // Add 1 for the "None" option
            itemBuilder: (context, index) {
              if (index == 0) {
                // "None" option at the top of the list
                return ListTile(
                  title: const Text('None'),
                  trailing: const Text("0%"),
                  onTap: () {
                     Navigator.pop(
                        context,
                     );
                  },
                );
              }

              final reward = rewards[index - 1]; // Adjust index for rewards list
              return ListTile(
                title: Text(reward.name),
                trailing: Text("${(reward.discountRate! * 100).toStringAsFixed(0)}%"),
                onTap: () {
                  Navigator.pop(context, reward); // Pass back selected reward
                },
              );
            },
          );
        },
      ),
    );
  }
}
