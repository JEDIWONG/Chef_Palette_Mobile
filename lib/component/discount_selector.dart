import 'package:flutter/material.dart';

class DiscountSelector extends StatelessWidget {
  const DiscountSelector({
    super.key,
    required this.onDiscountSelected,
    required this.current,
  });

  final Function(double) onDiscountSelected;
  final double current;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentMethod(onPaymentMethodSelected: onDiscountSelected)));
      },
      child: Container(
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
            color: Colors.green,
            width: 1,
          ),
        ),
        child: ListTile(
          title: Text(
            current == 0
                ? "No Discount Applied"
                : "Discount ${(current*100).toStringAsFixed(0)}% off",
            style: const TextStyle(fontSize: 16),
          ),
          trailing: const Icon(Icons.navigate_next_rounded),
        ),
      ),
    );
  }
}
