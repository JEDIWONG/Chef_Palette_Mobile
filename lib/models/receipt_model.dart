import 'package:chef_palette/models/cart_item_model.dart';

class Receipt {
  final String orderId;
  final List<CartItemModel> items;
  final double total;
  final String status;

  Receipt({
    required this.orderId,
    required this.items,
    required this.total,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

