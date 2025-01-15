import 'package:chef_palette/component/order_card.dart';
import 'package:chef_palette/controller/order_controller.dart';
import 'package:chef_palette/models/order_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/component/custom_button.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {  
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const CustomBackButton(title: "Account", first: false),
        leadingWidth: MediaQuery.sizeOf(context).width * 0.3,
        title:  Text("Transcation History",style: CustomStyle.h3,),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(  // Fetching all orders from three collections
        future: OrderController().getOrdersByUser(userId),
        builder: (context, snapshot) {
          // Show a loading indicator while the future is resolving
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle any error that might occur during fetching
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error fetching orders: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // Check if there are no orders or the data is null
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No orders found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          List<Map<String, dynamic>> completedOrdersWithIds = snapshot.data!
            .where((orderWithId) =>
                (orderWithId['order'] as OrderModel).status == "Complete")
            .toList();

            if (completedOrdersWithIds.isEmpty) {
          return const Center(
            child: Text(
              "No completed transactions yet. \nStart ordering!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          );
        }
          // If data is available, display the list of orders
          List<Map<String, dynamic>> ordersWithIds = snapshot.data!;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: ordersWithIds.length,
              itemBuilder: (context, index) {
                      if (index >= completedOrdersWithIds.length) {
        return const SizedBox.shrink();
      }
                // Extract the document ID and OrderModel
                final orderId = completedOrdersWithIds[index]['id'] as String;
                final order = completedOrdersWithIds[index]['order'] as OrderModel;

                return OrderCard(
                  orderId: orderId, 
                  status: order.status, 
                  datetime: order.timestamp,
                  orderType: order.orderType,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
