import 'package:chef_palette/screen/discount.dart';
import 'package:flutter/material.dart';

class DiscountSelector extends StatefulWidget {
  const DiscountSelector({
    super.key,
    required this.onDiscountSelected,
    required this.current,
  });

  final Function(double) onDiscountSelected;
  final double current;

  @override
  _DiscountSelectorState createState() => _DiscountSelectorState();
}

class _DiscountSelectorState extends State<DiscountSelector> {
  String rewardName = "No Discount Applied";
  double discountRate = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Navigate to RewardSelectionScreen and wait for result
        final selectedReward = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RewardSelectionScreen()),
        );

        // Check if a reward was selected and update the state
        if (selectedReward != null) {
          setState(() {
            rewardName = selectedReward.name;
            discountRate = selectedReward.discountRate ?? 0;
          });

          // Pass the selected discount rate back for further use
          widget.onDiscountSelected(discountRate);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
            color: Colors.green,
            width: 1,
          ),
        ),
        child: ListTile(
          title: Text(
            rewardName,  // Update with the selected reward's name
            style: const TextStyle(fontSize: 16),
          ),
          trailing: const Icon(Icons.navigate_next_rounded),
        ),
      ),
    );
  }
}
