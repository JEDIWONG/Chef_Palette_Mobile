import 'package:flutter/material.dart';

class PaymentSelector extends StatelessWidget{
  const PaymentSelector({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration:  BoxDecoration(
        
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
         color: Colors.grey,
          width: 1,
        )
      ),

      child: const ListTile(
        title: Text("Select a Payment Method"),
        trailing: Icon(Icons.navigate_next_rounded),
      ),
    );
  }
}