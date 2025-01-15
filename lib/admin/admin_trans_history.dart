import 'package:chef_palette/component/order_card.dart';
import 'package:chef_palette/controller/order_controller.dart';
import 'package:chef_palette/models/order_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/component/custom_button.dart';
class AdminTransactionRecord extends StatefulWidget {
  @override
  _AdminTransactionRecordState createState() => _AdminTransactionRecordState();
}

class _AdminTransactionRecordState extends State<AdminTransactionRecord> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCompletedTransactions();
  }

  Future<void> fetchCompletedTransactions() async {
    try {
      final db = FirebaseFirestore.instance;

      // Query to fetch all completed transactions
      final querySnapshot = await db
          .collection('transactions') // Adjust this to match your database structure
          .where('status', isEqualTo: 'completed')
          .get();

      setState(() {
        transactions = querySnapshot.docs
            .map((doc) => {
                  'userId': doc['userId'],
                  'orderId': doc['orderId'],
                  'items': doc['items'], // List of items
                  'total': doc['total'],
                  'timestamp': doc['timestamp'],
                })
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching transactions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Completed Transactions"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactions.isEmpty
              ? const Center(
                  child: Text(
                    "No completed transactions found.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          "Order ID: ${transaction['orderId']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("User ID: ${transaction['userId']}"),
                            const SizedBox(height: 5),
                            Text(
                              "Total: \$${transaction['total']}",
                              style: const TextStyle(color: Colors.green),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Date: ${DateTime.parse(transaction['timestamp']).toLocal()}",
                            ),
                          ],
                        ),
                        onTap: () {
                          showTransactionDetails(context, transaction);
                        },
                      ),
                    );
                  },
                ),
    );
  }

  void showTransactionDetails(
      BuildContext context, Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Order ID: ${transaction['orderId']}"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("User ID: ${transaction['userId']}"),
                const SizedBox(height: 10),
                Text("Items:"),
                ...List<dynamic>.from(transaction['items']).map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "${item['quantity']} x ${item['name']} @ \$${item['price']} = \$${item['quantity'] * item['price']}",
                    ),
                  );
                }).toList(),
                const Divider(),
                Text(
                  "Total: \$${transaction['total']}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
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
  }
}
