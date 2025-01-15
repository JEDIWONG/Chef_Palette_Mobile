// ignore_for_file: avoid_print
import 'package:chef_palette/models/delivery_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryOrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a delivery order
  Future<void> createDeliveryOrder(DeliveryOrderModel order) async {
    try {
      await _firestore.collection('delivery_orders').add(order.toMap());
      print('Delivery order created successfully');
    } catch (e) {
      print('Error creating delivery order: $e');
    }
  }

  // Fetch delivery orders by userID
  Future<List<Map<String, dynamic>>> getDeliveryOrdersByUser(String userID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('delivery_orders')
          .where('userID', isEqualTo: userID)
          .get();

      List<Map<String, dynamic>> orders = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "order": DeliveryOrderModel.fromMap(doc.data() as Map<String, dynamic>)
        };
      }).toList();

      return orders;
    } catch (e) {
      print('Error fetching delivery orders: $e');
      return [];
    }
  }

  // Fetch a delivery order by ID
  Future<Map<String, dynamic>?> getDeliveryOrderById(String orderID) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('delivery_orders').doc(orderID).get();

      if (docSnapshot.exists) {
        return {
          "id": docSnapshot.id,
          "order": DeliveryOrderModel.fromMap(docSnapshot.data() as Map<String, dynamic>)
        };
      } else {
        print('No delivery order found with ID: $orderID');
        return null;
      }
    } catch (e) {
      print('Error fetching delivery order by ID: $e');
      return null;
    }
  }

  // Update delivery order status
  Future<void> updateDeliveryOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('delivery_orders').doc(orderId).update({
        'status': newStatus,
      });
      print('Delivery order status updated to $newStatus');
    } catch (e) {
      print('Error updating delivery order status: $e');
    }
  }
}
