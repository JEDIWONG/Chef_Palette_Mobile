import 'package:flutter/material.dart';

class TransactionRecord extends StatelessWidget{
  const TransactionRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Transaction Record"),
          ],
        ),
      ),
    );
  }
  
}