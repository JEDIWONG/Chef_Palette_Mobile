import "package:chef_palette/admin/component/reward_tile.dart";
import "package:chef_palette/admin/create_reward.dart";
import "package:chef_palette/component/custom_button.dart";
import "package:chef_palette/style/style.dart";
import "package:flutter/material.dart";
import "package:chef_palette/controller/reward_controller.dart";
import "package:chef_palette/models/reward_model.dart";

class AdminRewards extends StatefulWidget {
  const AdminRewards({super.key});

  @override
  _AdminRewardsState createState() => _AdminRewardsState();
}

class _AdminRewardsState extends State<AdminRewards> {
  final RewardController _rewardController = RewardController();
  List<RewardModel> rewards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRewards();
  }

  Future<void> fetchRewards() async {
    try {
      List<RewardModel> fetchedRewards = await _rewardController.getAllRewards();
      setState(() {
        rewards = fetchedRewards;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch rewards: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
        leading: const CustomBackButton(
          title: 'Back',
          first: false,
        ),
        title: Text(
          "Manage Rewards",
          style: CustomStyle.h3,
        ),
      ),

      bottomSheet: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          fixedSize: Size(MediaQuery.sizeOf(context).width, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateReward()),
          );
        },
        child: const Text("Add Rewards"),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rewards.isEmpty
              ? const Center(child: Text("No rewards found."))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: rewards.length,
                  itemBuilder: (context, index) {
                    final reward = rewards[index];
                    return RewardTile(
                      name: reward.name,
                      type: reward.type,
                      expiryDate: reward.expiryDate != null
                          ? "${reward.expiryDate!.day}-${reward.expiryDate!.month}-${reward.expiryDate!.year}"
                          : "No Expiry",
                      rewardId: reward.id,
                    );
                  },
                ),
    );
  }
}