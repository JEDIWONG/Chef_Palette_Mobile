import 'package:chef_palette/controller/reward_controller.dart';
import 'package:chef_palette/models/reward_model.dart';
import 'package:flutter/material.dart';


class CreateReward extends StatefulWidget {
  const CreateReward({super.key});

  @override
  _CreateRewardState createState() => _CreateRewardState();
}

class _CreateRewardState extends State<CreateReward> {
  final _formKey = GlobalKey<FormState>();
  final RewardController _rewardController = RewardController(); // Instantiate the controller

  // Form field values
  String name = '';
  String description = '';
  int pointsRequired = 0;
  bool isActive = true;
  DateTime? expiryDate;
  String type = 'Discount'; // Default type
  String? freeItem; // Free item field
  double? discountRate; // Discount rate field

  // Reward types for the dropdown
  final List<String> rewardTypes = ['Discount', 'Free Item'];
  final List<double> discountRates = [0.05, 0.10, 0.15, 0.20]; // 5%, 10%, 15%, 20%

  Future<void> _createReward() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a RewardModel instance
      final reward = RewardModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate unique ID
        name: name,
        description: description,
        pointsRequired: pointsRequired,
        isActive: isActive,
        expiryDate: expiryDate,
        type: type,
        discountRate: type == 'Discount' ? discountRate : null,
        itemsFree: type == 'Free Item' ? freeItem : null,
      );

      try {
        // Add the reward to Firestore
        await _rewardController.createReward(reward);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reward Created Successfully')),
        );

        // Clear the form
        _formKey.currentState!.reset();
        setState(() {
          name = '';
          description = '';
          pointsRequired = 0;
          isActive = true;
          expiryDate = null;
          type = 'Discount';
          freeItem = null;
          discountRate = null;
        });
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create reward: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Reward'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reward Name
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Reward Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the reward name';
                    }
                    return null;
                  },
                  onSaved: (value) => name = value!,
                ),
                const SizedBox(height: 16),

                // Reward Description
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) => description = value!,
                ),
                const SizedBox(height: 16),

                // Points Required
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Points Required',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) => pointsRequired = int.parse(value!),
                ),
                const SizedBox(height: 16),

                // Reward Type Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Reward Type',
                    border: OutlineInputBorder(),
                  ),
                  value: type,
                  items: rewardTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      type = value!;
                      freeItem = null;
                      discountRate = null;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Dynamic Input Based on Reward Type
                if (type == 'Free Item') ...[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Free Item',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (type == 'Free Item' && (value == null || value.isEmpty)) {
                        return 'Please specify the free item';
                      }
                      return null;
                    },
                    onSaved: (value) => freeItem = value,
                  ),
                ] else if (type == 'Discount') ...[
                  DropdownButtonFormField<double>(
                    decoration: const InputDecoration(
                      labelText: 'Discount Rate',
                      border: OutlineInputBorder(),
                    ),
                    value: discountRate,
                    items: discountRates.map((rate) {
                      return DropdownMenuItem(
                        value: rate,
                        child: Text('${(rate * 100).toStringAsFixed(0)}%'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        discountRate = value;
                      });
                    },
                    validator: (value) {
                      if (type == 'Discount' && value == null) {
                        return 'Please select a discount rate';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),

                // Expiry Date Picker
                Row(
                  children: [
                    const Text('Expiry Date: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(expiryDate != null
                          ? "${expiryDate!.day}-${expiryDate!.month}-${expiryDate!.year}"
                          : "No date selected"),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            expiryDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Is Active Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value!;
                        });
                      },
                    ),
                    const Text('Active'),
                  ],
                ),
                const SizedBox(height: 24),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _createReward, // Trigger the reward creation
                    child: const Text('Create Reward'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
