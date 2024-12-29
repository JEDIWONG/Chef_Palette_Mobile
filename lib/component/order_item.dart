import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  const OrderItem(
      {super.key, required this.name, required this.price, required this.quantity});

  final String name;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("$quantity x"),
      title: Text(name),
      trailing: Text("RM ${price.toStringAsFixed(2)}"),
    );
  }
}