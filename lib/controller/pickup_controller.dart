import 'package:chef_palette/models/pickup_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PickupOrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a pickup order
  Future<void> createPickupOrder(PickupOrderModel order) async {
    try {
      await _firestore.collection('pickup_orders').add(order.toMap());
      print('Pickup order created successfully');
    } catch (e) {
      print('Error creating pickup order: $e');
    }
  }

  // Fetch pickup orders by userID
  Future<List<Map<String, dynamic>>> getPickupOrdersByUser(String userID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('pickup_orders')
          .where('userID', isEqualTo: userID)
          .get();

      List<Map<String, dynamic>> orders = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "order": PickupOrderModel.fromMap(doc.data() as Map<String, dynamic>)
        };
      }).toList();

      return orders;
    } catch (e) {
      print('Error fetching pickup orders: $e');
      return [];
    }
  }

  // Fetch a pickup order by ID
  Future<Map<String, dynamic>?> getPickupOrderById(String orderID) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('pickup_orders').doc(orderID).get();

      if (docSnapshot.exists) {
        return {
          "id": docSnapshot.id,
          "order": PickupOrderModel.fromMap(docSnapshot.data() as Map<String, dynamic>)
        };
      } else {
        print('No pickup order found with ID: $orderID');
        return null;
      }
    } catch (e) {
      print('Error fetching pickup order by ID: $e');
      return null;
    }
  }

  // Update pickup order status
  Future<void> updatePickupOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('pickup_orders').doc(orderId).update({
        'status': newStatus,
      });
      print('Pickup order status updated to $newStatus');
    } catch (e) {
      print('Error updating pickup order status: $e');
    }
  }
}
