// ignore_for_file: avoid_print
  
import 'package:chef_palette/models/delivery_model.dart';
import 'package:chef_palette/models/dine_in_model.dart';
import 'package:chef_palette/models/pickup_model.dart';
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

  // Method to get orders from all three collections (Dine-In, Pickup, Delivery)
  Future<List<Map<String, dynamic>>> getOrdersByUser(String userId) async {
    try {
      List<Map<String, dynamic>> allOrders = [];

      // Fetch Dine-In Orders
      QuerySnapshot dineInSnapshot = await _firestore
          .collection('dine_in_orders')
          .where('userID', isEqualTo: userId)
          .get();
      dineInSnapshot.docs.forEach((doc) {
        allOrders.add({
          "id": doc.id,
          "order": DineInOrderModel.fromMap(doc.data() as Map<String, dynamic>),
        });
      });

      // Fetch Pickup Orders
      QuerySnapshot pickupSnapshot = await _firestore
          .collection('pickup_orders')
          .where('userID', isEqualTo: userId)
          .get();
      pickupSnapshot.docs.forEach((doc) {
        allOrders.add({
          "id": doc.id,
          "order": PickupOrderModel.fromMap(doc.data() as Map<String, dynamic>),
        });
      });

      // Fetch Delivery Orders
      QuerySnapshot deliverySnapshot = await _firestore
          .collection('delivery_orders')
          .where('userID', isEqualTo: userId)
          .get();
      deliverySnapshot.docs.forEach((doc) {
        allOrders.add({
          "id": doc.id,
          "order": DeliveryOrderModel.fromMap(doc.data() as Map<String, dynamic>),
        });
      });

      return allOrders;
    } catch (e) {
      print('Error fetching orders from all collections: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
  try {
    // Map collection names to their respective models
    final collectionModelMapping = {
      'dine_in_orders': (data) => DineInOrderModel.fromMap(data),
      'pickup_orders': (data) => PickupOrderModel.fromMap(data),
      'delivery_orders': (data) => DeliveryOrderModel.fromMap(data),
    };

    // Iterate over the collections to find the order
    for (String collection in collectionModelMapping.keys) {
      final orderSnapshot = await _firestore.collection(collection).doc(orderId).get();

      if (orderSnapshot.exists) {
        final orderData = orderSnapshot.data() as Map<String, dynamic>;
        final orderModel = collectionModelMapping[collection]!(orderData);
        return {'order': orderModel, 'collection': collection};
      }
    }

    // If no order is found in any collection
    return null;
  } catch (e) {
    print("Error fetching order: $e");
    return null;
  }
}

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      final collections = ['dine_in_orders', 'pickup_orders', 'delivery_orders'];
      List<Map<String, dynamic>> allOrders = [];

      for (String collection in collections) {
        final querySnapshot = await _firestore.collection(collection).get();
        for (var doc in querySnapshot.docs) {
          final orderData = doc.data();
          final orderType = collection.replaceAll('_orders', ''); // e.g., "dine_in"
          allOrders.add({
            'id': doc.id,
            'order': OrderModel.fromMap(orderData),
            'orderType': orderType,
          });
        }
      }

      return allOrders;
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  // Update order status based on orderId and orderType
  Future<void> updateOrderStatus(String orderId, String newStatus, String orderType) async {
    try {
      // Dynamically select the collection based on orderType
      String collectionName = '';
      switch (orderType) {
        case 'dine_in':
          collectionName = 'dine_in_orders';
          break;
        case 'pickup':
          collectionName = 'pickup_orders';
          break;
        case 'delivery':
          collectionName = 'delivery_orders';
          break;
        default:
          throw 'Invalid order type';
      }

      // Update the status in the correct collection
      await _firestore.collection(collectionName).doc(orderId).update({
        'status': newStatus,
      });
    } catch (e) {
      throw 'Failed to update order status: $e';
    }
  } 

}
