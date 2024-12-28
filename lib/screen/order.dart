import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/order_card.dart';
import 'package:chef_palette/controller/order_controller.dart';
import 'package:chef_palette/models/order_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  const Order({super.key});

  @override
  Widget build(BuildContext context) {  
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
        leading: const CustomBackButton(
          title: 'Menu',
          first: true,
        ),
        title: Text(
          "Orders",
          style: CustomStyle.h1,
        ),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: OrderController().getOrdersByUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error fetching orders: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No orders found",
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            // Display the list of orders
            List<OrderModel> orders = snapshot.data!;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCard(
                    orderItems: order.orderItems,
                    status: order.status,
                    datetime: order.timestamp,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
