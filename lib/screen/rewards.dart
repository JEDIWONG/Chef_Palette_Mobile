import "package:chef_palette/component/custom_button.dart";
import "package:chef_palette/models/user_reward_model.dart";
import "package:chef_palette/style/style.dart";
import "package:flutter/material.dart";
import "package:syncfusion_flutter_gauges/gauges.dart";

class Rewards extends StatefulWidget {
  const Rewards({super.key});

  @override
  createState() => _RewardsState();
}

class _RewardsState extends State<Rewards> {
  // Example user data
  final userReward = UserRewardModel(
    userId: 'user123',
    totalPoints: 1000,
    totalPointsAccumulated: 2500,
    tier: 'Silver',
    redeemedRewards: [],
    lastUpdated: DateTime.now(),
  );

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
        body: TabBarView(
          children: [
            RewardsRedeem(userReward: userReward),
            const Center(
              child: Text("Earned Rewards Feature Coming Soon"),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardsRedeem extends StatelessWidget {
  final UserRewardModel userReward;

  const RewardsRedeem({super.key, required this.userReward});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Gauge for Points Tier
          Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 50),
            child: SfRadialGauge(
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
                      widget: Text(
                        '${userReward.totalPoints} Points',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      angle: 90,
                      positionFactor: 0.8,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Your Tier: ${userReward.tier}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          // Redeem Cards
          RedeemCard(title: "Free Nasi Lemak Pop", quantity: 1, score: 3000),
          RedeemCard(title: "Free Coffee", quantity: 1, score: 1000),
          RedeemCard(title: "Free Ice Cream", quantity: 1, score: 3000),
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
  });

  final String title;
  final int quantity;
  final int score;

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
            child: RectButton(
              bg: Colors.green,
              fg: Colors.black,
              text: "Redeem",
              func: () {
                if (score <= 1000) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Redeemed successfully!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Not enough points to redeem.")),
                  );
                }
              },
              rad: 10,
            ),
          ),
        ],
      ),
    );
  }
}
