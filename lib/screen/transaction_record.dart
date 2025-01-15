import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/models/cart_item_model.dart';
import 'package:chef_palette/models/receipt_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/models/user_transaction_records_model.dart';
import 'package:intl/intl.dart';

List<UserTransactionRecordsModel> transactions = [
   UserTransactionRecordsModel(orderId: '1', orderType: 'Groceries', paymentMethod: 'Cash', price: 50.5, timestamp: DateTime.now(), userID: 'user1'),
   UserTransactionRecordsModel(orderId: '2', orderType: 'Books', paymentMethod: 'Card', price: 30.0, timestamp: DateTime.now().subtract(Duration(days: 1)), userID: 'user2'),
   UserTransactionRecordsModel(orderId: '3', orderType: 'Restaurant', paymentMethod: 'Cash', price: 75.0, timestamp: DateTime.now().subtract(Duration(days: 2)), userID: 'user3'),

];

Future<Receipt?> fetchReceipt(String orderId) async {
  try {
    final db = FirebaseFirestore.instance;

    // Query the Firestore database for the receipt by orderId
    final querySnapshot = await db
        .collection('receipts')
        .where('orderId', isEqualTo: orderId)
        .get();

    // Check if a receipt exists
    if (querySnapshot.docs.isNotEmpty) {
      // Convert the first document into a Receipt object
      final receiptData = querySnapshot.docs.first.data();
      return Receipt(
        orderId: receiptData['orderId'],
        items: (receiptData['items'] as List<dynamic>)
            .map((item) => CartItemModel(
              productId: item['productId'],
              itemId: item['itemId'],
                  name: item['name'],
                  price: item['price'],
                  quantity: item['quantity'],
                  imageUrl: item['imageUrl'],
                  addons: item['addons'],
                  instruction: item['instruction'],
                ))
            .toList(),
        total: receiptData['total'],
        status: receiptData['status'],
      );
    } else {
      print("No receipt found for this Order ID");
      return null;
    }
  } catch (e) {
    print("Error fetching receipt: $e");
    return null;
  }
}

void viewReceipt(BuildContext context, String orderId) async {
  // Fetch the receipt
  final receipt = await fetchReceipt(orderId);

  if (receipt != null) {
    // Display the receipt in a dialog or new page
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Receipt for Order ID: ${receipt.orderId}"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Items:"),
                const SizedBox(height: 10),
                ...receipt.items.map((item) => Text(
                      "${item.quantity} x ${item.name} @ \$${item.price} = \$${(item.quantity * item.price).toStringAsFixed(2)}",
                    )),
                const Divider(),
                Text("Total: \$${receipt.total.toStringAsFixed(2)}"),
                const SizedBox(height: 10),
                Text("Status: ${receipt.status}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  } else {
    // Show an error message if the receipt is not found
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Receipt Not Found"),
          content: Text("No receipt found for Order ID: $orderId"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}


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
      body: 
      ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (ctx, index) {
          final tx = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child:GestureDetector(
              onTap: (){
                 // viewReceipt(context, orderId);
              },
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
            ),
          );
        },
      ),
    );
  }
  
}