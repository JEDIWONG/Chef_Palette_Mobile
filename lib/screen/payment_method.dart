import 'package:chef_palette/style/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentMethod extends StatelessWidget {
  final Function(String) onPaymentMethodSelected; // Callback to notify parent

  const PaymentMethod({super.key, required this.onPaymentMethodSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> paymentOptions = ["Cash", "Online Banking", "Card"];
    final List <IconData> icons = [Icons.attach_money_rounded,CupertinoIcons.money_dollar_circle_fill,CupertinoIcons.creditcard_fill ];  

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Select Payment Method"),
      ),
      body: ListView.builder(
        itemCount: paymentOptions.length,
        itemBuilder: (context, index) {
          final option = paymentOptions[index];
          final icon = icons[index]; 
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1, 1),
                  blurRadius: 0.5,
                  blurStyle: BlurStyle.outer
                )
              ]
            ),
            child: ListTile(
              leading: Icon(icon),
              title: Text(option,style: CustomStyle.h5,),
              onTap: () {
                onPaymentMethodSelected(option); 
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
