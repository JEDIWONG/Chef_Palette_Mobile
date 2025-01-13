import 'package:flutter/material.dart';
import 'package:chef_palette/controller/user_transaction_records_controller.dart';
import 'package:chef_palette/models/cart_item_model.dart';
import 'package:chef_palette/models/order_model.dart';
import 'package:chef_palette/models/user_transaction_records_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:intl/intl.dart';

class AdminTransactionDetail extends StatefulWidget {
  const AdminTransactionDetail({
    super.key,
    required this.transactionId,
  });

  final String transactionId;

  @override
  State<AdminTransactionDetail> createState() => _AdminTransactionDetailState();
}

class _AdminTransactionDetailState extends State<AdminTransactionDetail> {
  final TransactionController _transactionController = TransactionController();
  late Future<Map<String, dynamic>?> transactionFuture;

  @override
  void initState() {
    super.initState();
    transactionFuture = _transactionController.getTransactionWithOrderDetails(widget.transactionId);
  }

  Widget _buildOrderItem(CartItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('${item.quantity}x', 
            style: const TextStyle(fontSize: 14, color: Colors.black87)
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(item.name, 
              style: const TextStyle(fontSize: 14, color: Colors.black87)
            ),
          ),
          Text('RM ${(item.price * item.quantity).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, color: Colors.black87)
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Transaction Detail', style: CustomStyle.h2),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: transactionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red)
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Transaction not found',
                style: TextStyle(fontSize: 16)
              ),
            );
          }

          final UserTransactionRecordsModel transaction = snapshot.data!['transaction'];
          final OrderModel order = snapshot.data!['order'];

          // Calculate subtotal from the actual order items
          double subtotal = order.orderItems.fold(
            0, 
            (sum, item) => sum + (item.price * item.quantity)
          );
          const double packagingFee = 0.50;
          final double sst = subtotal * 0.08;
          final double total = subtotal + packagingFee + sst;

          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Info Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order ID: ${transaction.orderId}', // Using transaction orderId
                        style: const TextStyle(fontSize: 14)
                      ),
                      Text(
                        DateFormat('HH:mm').format(transaction.timestamp),
                        style: const TextStyle(fontSize: 14)
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Payment Method: ${transaction.paymentMethod}',
                    style: const TextStyle(fontSize: 14)
                  ),
                  Text('Order Type: ${order.orderType}',
                    style: const TextStyle(fontSize: 14)
                  ),
                  Text('Branch: ${order.branchName}',
                    style: const TextStyle(fontSize: 14)
                  ),
                  const Divider(height: 24),

                  // Order Items Section
                  const Text('Order summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  ),
                  const SizedBox(height: 12),
                  ...order.orderItems.map((item) => _buildOrderItem(item)).toList(),
                  const Divider(height: 24),

                  // Price Breakdown Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sub-total:',
                        style: TextStyle(fontSize: 14)
                      ),
                      Text('RM ${subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14)
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (order.orderType == 'Takeaway')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Takeaway Packaging:',
                          style: TextStyle(fontSize: 14)
                        ),
                        Text('RM ${packagingFee.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14)
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('SST (8%):',
                        style: TextStyle(fontSize: 14)
                      ),
                      Text('RM ${sst.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14)
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Total Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text('RM ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),

                  // Additional Transaction Info
                  const Divider(height: 24),
                  Text('Transaction ID: ${transaction.orderId}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)
                  ),
                  Text('Transaction Date: ${DateFormat('yyyy-MM-dd').format(transaction.timestamp)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)
                  ),
                  Text('Order Status: ${order.status}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}