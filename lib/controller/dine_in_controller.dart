import 'package:chef_palette/models/dine_in_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DineInOrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to create a DineIn order in Firestore
  Future<void> createDineInOrder(DineInOrderModel dineInOrder) async {
    try {
      // Add the DineIn order to Firestore collection "dine_in_orders"
      await _firestore.collection('dine_in_orders').add(dineInOrder.toMap());
      print('Dine-In Order created successfully');
    } catch (e) {
      print('Error creating Dine-In order: $e');
      throw Exception('Failed to create Dine-In order');
    }
  }

  // Method to fetch all DineIn orders for a user
  Future<List<Map<String, dynamic>>> getDineInOrdersByUser(String userID) async {
    try {
      // Query the Firestore collection "dine_in_orders" to get orders by userID
      QuerySnapshot querySnapshot = await _firestore
          .collection('dine_in_orders')
          .where('userID', isEqualTo: userID)
          .get();

      // Map the query result to a list of maps containing document ID and DineInOrderModel
      List<Map<String, dynamic>> orders = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id, // Document ID
          "order": DineInOrderModel.fromMap(doc.data() as Map<String, dynamic>) // DineInOrderModel object
        };
      }).toList();

      return orders;
    } catch (e) {
      print('Error fetching Dine-In orders: $e');
      return [];
    }
  }

  // Method to fetch a single DineIn order by its ID
  Future<Map<String, dynamic>?> getDineInOrderById(String orderID) async {
    try {
      // Fetch the document by its ID
      DocumentSnapshot docSnapshot =
          await _firestore.collection('dine_in_orders').doc(orderID).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Return a map containing the document ID and the DineInOrderModel
        return {
          "id": docSnapshot.id, // Document ID
          "order": DineInOrderModel.fromMap(docSnapshot.data() as Map<String, dynamic>) // DineInOrderModel object
        };
      } else {
        print('No Dine-In order found with ID: $orderID');
        return null;
      }
    } catch (e) {
      print('Error fetching Dine-In order by ID: $e');
      return null;
    }
  }

  // Method to fetch all DineIn orders
  Future<List<Map<String, dynamic>>> getAllDineInOrders() async {
    try {
      // Query the Firestore collection "dine_in_orders" to get all orders
      QuerySnapshot querySnapshot = await _firestore.collection('dine_in_orders').get();

      // Map the query result to a list of maps containing document ID and DineInOrderModel
      List<Map<String, dynamic>> orders = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id, // Document ID
          "userID": doc['userID'], // User ID associated with the order
          "order": DineInOrderModel.fromMap(doc.data() as Map<String, dynamic>) // DineInOrderModel object
        };
      }).toList();

      return orders;
    } catch (e) {
      print('Error fetching all Dine-In orders: $e');
      return [];
    }
  }

  // Method to update the status of a DineIn order based on its ID
  Future<void> updateDineInOrderStatus(String orderId, String newStatus) async {
    try {
      // Reference the specific DineIn order document by its ID and update the status field
      await _firestore.collection('dine_in_orders').doc(orderId).update({
        'status': newStatus,
      });
      print('Dine-In Order status updated successfully to $newStatus');
    } catch (e) {
      print('Error updating Dine-In order status: $e');
      throw Exception('Failed to update Dine-In order status');
    }
  }
}
