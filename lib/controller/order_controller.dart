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

  Future<List<Map<String, dynamic>>> getOrdersByUser(String userID) async {
    try {
      // Query the Firestore collection "orders" to get orders by userID
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userID', isEqualTo: userID)
          .get();

      // Map the query result to a list of maps containing document ID and OrderModel
      List<Map<String, dynamic>> orders = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id, // Document ID
          "order": OrderModel.fromMap(doc.data() as Map<String, dynamic>) // OrderModel object
        };
      }).toList();

      return orders;
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getOrderById(String orderID) async {
    try {
      // Fetch the document by its ID
      DocumentSnapshot docSnapshot =
          await _firestore.collection('orders').doc(orderID).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Return a map containing the document ID and the OrderModel
        return {
          "id": docSnapshot.id, // Document ID
          "order": OrderModel.fromMap(docSnapshot.data() as Map<String, dynamic>) // OrderModel object
        };
      } else {
        print('No order found with ID: $orderID');
        return null;
      }
    } catch (e) {
      print('Error fetching order by ID: $e');
      return null;
    }
  }


}
