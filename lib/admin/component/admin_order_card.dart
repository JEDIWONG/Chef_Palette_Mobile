import 'package:chef_palette/admin/admin_order_status.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AdminOrderCard extends StatelessWidget {
  const AdminOrderCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.datetime,
  });

  final String orderId;
  final String status;
  final DateTime datetime;

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
            builder: (context) => AdminOrderStatus(
              orderId: orderId,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          title: Text(
            status,
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
