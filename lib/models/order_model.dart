import 'package:chef_palette/models/cart_item_model.dart';

class OrderModel {
  final String paymentMethod;
  final DateTime timestamp;
  final String userID;
  final String branchName;
  final List<CartItemModel> orderItems;
  final double price;
  final String status;
  final String orderType;

  OrderModel({
    
    required this.paymentMethod,
    required this.timestamp,
    required this.userID,
    required this.branchName,
    required this.orderItems,
    required this.price,
    required this.status, 
    required this.orderType, 
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentMethod': paymentMethod,
      'timestamp': timestamp.toIso8601String(),
      'userID': userID,
      'branchName': branchName,
      'orderItems': orderItems.map((item) => item.toMap()).toList(), 
      'price': price,
      'status':status,
      'orderType':orderType,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      paymentMethod: map['paymentMethod'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      userID: map['userID'] ?? '',
      branchName: map['branchName'] ?? '',
      orderItems: List<CartItemModel>.from(
        (map['orderItems'] as List).map((item) => CartItemModel.fromMap(item)),
      ),
      price: map['price']??0,
      status: map['status']??'Pending', 
      orderType: map['orderType']??"Dine-In", 
    );
  }
}