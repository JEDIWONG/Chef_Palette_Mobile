import 'package:chef_palette/screen/payment_method.dart';
import 'package:flutter/material.dart';

class PaymentSelector extends StatelessWidget{
  const PaymentSelector({super.key, required this.onPaymentMethodSelected, required this.current});

  final Function(String) onPaymentMethodSelected;
  final String current;
  
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentMethod(onPaymentMethodSelected: onPaymentMethodSelected)));
      },
      child: Container(
      
        decoration:  BoxDecoration(

          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
          color: Colors.green,
            width: 1,
          )
        ),

        child:  ListTile(
          title: Text(current),
          trailing:const Icon(Icons.navigate_next_rounded),
        ),
      ),
    );
  }
}