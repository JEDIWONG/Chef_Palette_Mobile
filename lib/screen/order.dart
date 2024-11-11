import 'package:flutter/material.dart';

class Order extends StatelessWidget{
  const Order({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Order page")
          ],
        ),
      ),
    );
  }
  
}