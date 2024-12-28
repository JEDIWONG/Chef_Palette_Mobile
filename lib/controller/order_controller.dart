// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chef_palette/models/order_model.dart'; 

class OrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to create an order in Firestore
  Future<void> createOrder(OrderModel order) async {
    try {
      // Add the order to Firestore collection "orders"
      await _firestore.collection('orders').add(order.toMap());
      print('Order created successfully');
    } catch (e) {
      print('Error creating order: $e');
    }

  }

  // Method to fetch orders by userID
  Future<List<OrderModel>> getOrdersByUser(String userID) async {
    try {
      // Query the Firestore collection "orders" to get orders by userID
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userID', isEqualTo: userID)
          .get();

      // Map the query result to a list of OrderModel objects
      List<OrderModel> orders = querySnapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return orders;
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }
}
