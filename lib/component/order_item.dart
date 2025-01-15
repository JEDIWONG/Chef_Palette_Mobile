import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.name,
    required this.price,
    required this.quantity,
    required this.addons,
  });

  final String name;
  final double price;
  final int quantity;
  final List<Map<String, dynamic>> addons;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header ListTile
        ListTile(
          leading: Text("$quantity x"),
          title: Text(name),
          trailing: Text("RM ${price.toStringAsFixed(2)}"),
        ),

        // Addons List
        if (addons.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 72.0), // Indent addons to align under the ListTile
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: addons.map((addon) {
                final addonName = addon['name'] ?? 'Unknown';
                final addonPrice = addon['price'] ?? 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    "- $addonName (RM ${addonPrice.toStringAsFixed(2)})",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
