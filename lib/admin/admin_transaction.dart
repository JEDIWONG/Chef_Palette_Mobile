import 'package:flutter/material.dart';
import 'package:chef_palette/controller/user_transaction_records_controller.dart'; // Ensure correct import
import 'package:chef_palette/models/user_transaction_records_model.dart';

class AdminTransactionPage extends StatefulWidget {
  const AdminTransactionPage({Key? key}) : super(key: key);

  @override
  _AdminTransactionPageState createState() => _AdminTransactionPageState();
}

class _AdminTransactionPageState extends State<AdminTransactionPage> {
  final TransactionController _transactionController = TransactionController();
  List<UserTransactionRecordsModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions(); // Fetch transactions when page loads
  }

  // Fetch all transactions from the controller
  Future<void> _fetchTransactions() async {
    try {
      List<Map<String, dynamic>> transactions = await _transactionController.getAllTransactions();
      setState(() {
        _transactions = transactions
            .map((transaction) => UserTransactionRecordsModel.fromMap(transaction))
            .toList();
      });
    } catch (e) {
      _showErrorDialog('Error fetching transactions: $e');
    }
  }

  // Update a specific transaction by its orderId
  Future<void> _updateTransaction(String orderId) async {
    UserTransactionRecordsModel updatedTransaction = UserTransactionRecordsModel(
      orderId: orderId,
      orderType: 'Updated Type',
      paymentMethod: 'Updated Payment Method',
      price: 100.0,
      timestamp: DateTime.now(),
      userID: 'updatedUserId',
    );
    try {
      await _transactionController.updateTransaction(orderId, updatedTransaction);
      _fetchTransactions(); // Refresh the transaction list after update
    } catch (e) {
      _showErrorDialog('Error updating transaction: $e');
    }
  }

  // Delete a specific transaction by its orderId with confirmation dialog
  Future<void> _deleteTransaction(String orderId) async {
    // Show confirmation dialog
    bool? confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete != null && confirmDelete) {
      try {
        await _transactionController.deleteTransaction(orderId);
        _fetchTransactions(); // Refresh the transaction list after deletion
      } catch (e) {
        _showErrorDialog('Error deleting transaction: $e');
      }
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog for deleting a transaction
  Future<bool?> _showDeleteConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Transaction Records'),
      ),
      body: _transactions.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Loading indicator
          : ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return Card(
                  child: ListTile(
                    title: Text('Order ID: ${transaction.orderId}'),
                    subtitle: Text(
                        'Type: ${transaction.orderType} | Payment: ${transaction.paymentMethod} | Price: \$${transaction.price}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _updateTransaction(transaction.orderId),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _deleteTransaction(transaction.orderId),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
