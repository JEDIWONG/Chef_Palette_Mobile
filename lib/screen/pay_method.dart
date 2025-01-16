import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentMethod extends StatelessWidget {
 // final Function(String) onPaymentMethodSelected;

  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> paymentOptions = ["Cash", "Online Banking", "Card"];
    final List<IconData> icons = [Icons.attach_money_rounded, CupertinoIcons.money_dollar_circle_fill, CupertinoIcons.creditcard_fill];  

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
            margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1, 1),
                  blurRadius: 0.5,
                  blurStyle: BlurStyle.outer,
                )
              ]
            ),
            child: ListTile(
              leading: Icon(icon),
              title: Text(option),
              onTap: () async {
                // Save the selected payment method to Firebase
                await savePaymentMethod(option);
                
                // Call the callback function and notify the parent
                //onPaymentMethodSelected(option);

                // Close the current screen
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }

  // Function to save selected payment method to Firebase
  Future<void> savePaymentMethod(String paymentMethod) async {
    try {
      // Assuming user is already authenticated with Firebase Auth
      final userid = FirebaseAuth.instance.currentUser?.uid;

      final paymentMethodRef = FirebaseFirestore.instance.collection('users').doc(userid);
      
      // Save payment method to Firebase
      await paymentMethodRef.update({
        'paymentMethod': paymentMethod,
      });

      print('Payment method saved successfully!');
    } catch (e) {
      print('Error saving payment method: $e');
    }
  }
}
