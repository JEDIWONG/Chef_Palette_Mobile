import "package:chef_palette/controller/reward_controller.dart";
import "package:chef_palette/controller/user_rewards_controller.dart";
import "package:chef_palette/models/reward_model.dart";
import "package:chef_palette/models/user_reward_model.dart";
import "package:chef_palette/screen/rewards_earn.dart";
import "package:chef_palette/style/style.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:syncfusion_flutter_gauges/gauges.dart";

class Rewards extends StatefulWidget {
  const Rewards({super.key});

  @override
  createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  final UserRewardsController _userRewardsController = UserRewardsController();
  final RewardController _rewardController = RewardController();

  UserRewardModel? userReward;
  List<RewardModel> rewards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      
      var userId = FirebaseAuth.instance.currentUser?.uid;

      // Fetch user rewards
      final fetchedUserReward = await _userRewardsController.getUserRewards(userId!);

      // Fetch all available rewards
      final fetchedRewards = await _rewardController.getAllRewards();

      setState(() {
        userReward = fetchedUserReward;
        rewards = fetchedRewards;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Rewards", style: CustomStyle.h1),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Redeem"),
              Tab(text: "Earned"),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  RewardsRedeem(userReward: userReward!, rewards: rewards),
                  RewardsEarn(userReward: userReward!, allRewards: rewards,),
                ],
              ),
      ),
    );
  }
}

class RewardsRedeem extends StatelessWidget {
  final UserRewardModel userReward;
  final List<RewardModel> rewards;

  const RewardsRedeem({super.key, required this.userReward, required this.rewards});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          
          // Gauge for Points Tier
          Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 80),
            child: SfRadialGauge(
              title: GaugeTitle(text: "Membership Tier",textStyle: CustomStyle.h3),
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 3000,
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0,
                      endValue: 500,
                      color: const Color.fromARGB(255, 179, 80, 31),
                      label: 'Bronze',
                      sizeUnit: GaugeSizeUnit.factor,
                    ),
                    GaugeRange(
                      startValue: 500,
                      endValue: 2000,
                      color: const Color.fromARGB(255, 130, 130, 130),
                      label: 'Silver',
                      sizeUnit: GaugeSizeUnit.factor,
                    ),
                    GaugeRange(
                      startValue: 2000,
                      endValue: 3000,
                      color: const Color.fromARGB(255, 255, 183, 0),
                      label: 'Gold',
                      sizeUnit: GaugeSizeUnit.factor,
                    ),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(value: userReward.totalPoints.toDouble()),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Column(
                        spacing: 10,
                        children: [
                          Text(
                            '${userReward.totalPoints} Points',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.green,
                            ),
                          ),
                          Container(
                            
                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              userReward.tier,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )
                          
                        ],
                      ),
                      angle: 90,
                      positionFactor: 2.5,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.star_rate,color: Colors.amber,),
            title: Text("You Have ${userReward.totalPoints} points Left"),

          ),
          // Dynamic Redeem Cards
          ...rewards.map((reward) => RedeemCard(
                title: reward.name,
                quantity: 1,
                score: reward.pointsRequired,
                canRedeem: userReward.totalPoints >= reward.pointsRequired,
                onRedeem: () async {
                  if (userReward.totalPoints >= reward.pointsRequired) {
                    // Redeem logic
                    await UserRewardsController().redeemReward(
                      userReward.userId,
                      reward.id,
                      reward.pointsRequired,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Redeemed successfully!")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Not enough points to redeem.")),
                    );
                  }
                },
              )),
        ],
      ),
    );
  }
}

class RedeemCard extends StatelessWidget {
  const RedeemCard({
    super.key,
    required this.title,
    required this.quantity,
    required this.score,
    required this.canRedeem,
    required this.onRedeem,
  });

  final String title;
  final int quantity;
  final int score;
  final bool canRedeem;
  final VoidCallback onRedeem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            blurStyle: BlurStyle.normal,
            color: Colors.grey,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(title, style: CustomStyle.h4),
            trailing: Text("x $quantity", style: CustomStyle.txt),
            subtitle: Text("$score points", style: CustomStyle.subtitle),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(left: 150),
            child: ElevatedButton(
              onPressed: canRedeem ? onRedeem : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canRedeem ? Colors.green : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Redeem"),
            ),
          ),
        ],
      ),
    );
  }
}
