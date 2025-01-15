import 'package:cloud_firestore/cloud_firestore.dart';

class UserTransactionRecordsModel {
  final String orderId;  // Order ID related to the transaction
  final String orderType;  // The type of order (e.g., 'Dine-in', 'Takeaway')
  final String paymentMethod;  // Payment method used (e.g., 'Credit Card', 'Cash')
  final double price;  // Total price of the order
  final DateTime timestamp;  // The timestamp of the transaction
  final String userID;  // User ID associated with the transaction

  // Constructor to initialize the fields
  UserTransactionRecordsModel({
    required this.orderId,
    required this.orderType,
    required this.paymentMethod,
    required this.price,
    required this.timestamp,
    required this.userID,
  });

  // Method to convert the model to a map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,  // Include orderId in the map
      'orderType': orderType,  // Include orderType in the map
      'paymentMethod': paymentMethod,  // Include paymentMethod in the map
      'price': price,  // Include price in the map
      'timestamp': timestamp.toIso8601String(),  // Include timestamp in the map
      'userID': userID,  // Include userID in the map
    };
  }

  // Factory constructor to create a model from a map (from Firestore)
  factory UserTransactionRecordsModel.fromMap(Map<String, dynamic> map) {
    return UserTransactionRecordsModel(
      orderId: map['orderId'] ?? '',  // Extract orderId from the map
      orderType: map['orderType'] ?? '',  // Extract orderType from the map
      paymentMethod: map['paymentMethod'] ?? '',  // Extract paymentMethod from the map
      price: map['price']?.toDouble() ?? 0.0,  // Extract price from the map
      timestamp: (map['timestamp'] as Timestamp).toDate(),  // Extract timestamp from the map
      userID: map['userID'] ?? '',  // Extract userID from the map
    );
  }
}