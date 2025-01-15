import 'package:chef_palette/models/cart_item_model.dart';
import 'package:chef_palette/models/order_model.dart';

class PickupOrderModel extends OrderModel {
   final String pickupNo;

  PickupOrderModel({
    required String paymentMethod,
    required DateTime timestamp,
    required String userID,
    required String branchName,
    required List<CartItemModel> orderItems,
    required double price,
    required String status,
    required String orderType,
    required this.pickupNo,
  }) : super(
          paymentMethod: paymentMethod,
          timestamp: timestamp,
          userID: userID,
          branchName: branchName,
          orderItems: orderItems,
          price: price,
          status: status,
          orderType: orderType,
        );

  @override
  Map<String, dynamic> toMap() {
    final data = super.toMap();
    data['pickupNo'] = pickupNo;

    return data;
  }

  @override
  factory PickupOrderModel.fromMap(Map<String, dynamic> map) {
    return PickupOrderModel(
      paymentMethod: map['paymentMethod'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      userID: map['userID'] ?? '',
      branchName: map['branchName'] ?? '',
      orderItems: List<CartItemModel>.from(
        (map['orderItems'] as List).map((item) => CartItemModel.fromMap(item)),
      ),
      price: map['price'] ?? 0,
      status: map['status'] ?? 'Pending',
      orderType: map['orderType'] ?? 'Pickup',
      pickupNo: map["pickupNo"],
    );
  }
}
