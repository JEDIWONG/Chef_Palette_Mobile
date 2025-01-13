import 'package:chef_palette/admin/admin_transaction_detailS.dart'; // Assuming you have a TransactionDetail screen
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.transactionId,
    required this.orderId,
    required this.paymentMethod,
    required this.datetime,
  });

  final String transactionId;
  final String orderId;
  final String paymentMethod;
  final DateTime datetime;

  // Function to convert date to string format
  String convertDate() {
    return "${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminTransactionDetail(
              transactionId: transactionId, // Navigate to transaction detail
            ),
          ),
        );
      },
      child: Card(
        color: Colors.blue, // Change color to differentiate from OrderCard
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Text(
            paymentMethod,
            style: CustomStyle.lightH3,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Created On ${convertDate()}",
                style: CustomStyle.lightTxt,
              ),
              Text(
                "Order ID: $orderId",
                style: CustomStyle.lightTxt,
              ),
            ],
          ),
          trailing: const Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
