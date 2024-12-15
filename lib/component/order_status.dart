import 'package:flutter/material.dart';

class OrderStatus extends StatelessWidget{
  const OrderStatus({super.key, required this.order_no, required this.status});


  final int order_no;
  final int status;

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Column(
        children: [
          Text("Order Number : ")
          
        ],
      ),
    );
  }
  
}