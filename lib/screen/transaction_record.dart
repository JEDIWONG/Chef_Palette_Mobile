import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/models/user_transaction_records_model.dart';
import 'package:intl/intl.dart';

List<UserTransactionRecordsModel> transactions = [
   UserTransactionRecordsModel(orderId: '1', orderType: 'Groceries', paymentMethod: 'Cash', price: 50.5, timestamp: DateTime.now(), userID: 'user1'),
   UserTransactionRecordsModel(orderId: '2', orderType: 'Books', paymentMethod: 'Card', price: 30.0, timestamp: DateTime.now().subtract(Duration(days: 1)), userID: 'user2'),
   UserTransactionRecordsModel(orderId: '3', orderType: 'Restaurant', paymentMethod: 'Cash', price: 75.0, timestamp: DateTime.now().subtract(Duration(days: 2)), userID: 'user3'),

];

class TransactionRecord extends StatelessWidget{
  const TransactionRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(title: "Account", first: false),
        leadingWidth: MediaQuery.sizeOf(context).width * 0.3,
        title:  Text("Transaction Record",style: CustomStyle.h3,),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Text("Transaction Record"),
      //     ],
      //   ),
      // ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctx, index) {
          final tx = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Text('\$${tx.price.toStringAsFixed(2)}'),
                  ),
                ),
              ),
              title: Text(
                tx.orderType,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(tx.timestamp),
              ),
            ),
          );
        },
      ),
    );
  }
  
}