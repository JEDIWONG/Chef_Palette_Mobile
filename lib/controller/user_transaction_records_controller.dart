// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chef_palette/models/order_model.dart'; // Assuming you have this model
import 'package:chef_palette/models/user_transaction_records_model.dart'; // Import the transaction model

class TransactionController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to create a transaction record in Firestore
  Future<void> createTransaction(UserTransactionRecordsModel transaction) async {
    try {
      // Add the transaction to Firestore collection "transactions"
      await _firestore.collection('transactions').add(transaction.toMap());
      print('Transaction created successfully');
    } catch (e) {
      print('Error creating transaction: $e');
    }
  }

  // Method to get all transactions for a user
  Future<List<Map<String, dynamic>>> getTransactionsByUser(String userID) async {
    try {
      // Query the Firestore collection "transactions" to get transactions by userID
      QuerySnapshot querySnapshot = await _firestore
          .collection('transactions')
          .where('userID', isEqualTo: userID)
          .get();

      // Map the query result to a list of maps containing document ID and TransactionModel
      List<Map<String, dynamic>> transactions = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id, // Document ID
          "transaction": UserTransactionRecordsModel.fromMap(doc.data() as Map<String, dynamic>) // TransactionModel object
        };
      }).toList();

      return transactions;
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  // Method to get all transactions (all users)
  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    try {
      // Query the Firestore collection "transactions" to get all transactions
      QuerySnapshot querySnapshot = await _firestore.collection('transactions').get();

      // Map the query result to a list of maps containing document ID and TransactionModel
      List<Map<String, dynamic>> transactions = querySnapshot.docs.map((doc) {
        return {
          "id": doc.id, // Document ID
          "transaction": UserTransactionRecordsModel.fromMap(doc.data() as Map<String, dynamic>) // TransactionModel object
        };
      }).toList();

      return transactions;
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  // Method to get the transaction details by the order ID and include order details
  Future<Map<String, dynamic>?> getTransactionWithOrderDetails(String orderID) async {
    try {
      // Fetch the order by ID first
      var orderResult = await _firestore.collection('orders').doc(orderID).get();
      
      if (orderResult.exists) {
        OrderModel order = OrderModel.fromMap(orderResult.data() as Map<String, dynamic>);

        // Fetch the related transaction for the order
        var transactionResult = await getTransactionByOrderId(orderID);

        if (transactionResult != null) {
          // Combine order and transaction details
          var transaction = transactionResult["transaction"] as UserTransactionRecordsModel;

          return {
            "order": order,  // The OrderModel object
            "transaction": transaction  // The UserTransactionRecordsModel object
          };
        } else {
          print('No transaction found for the order: $orderID');
          return null;
        }
      } else {
        print('Order not found with ID: $orderID');
        return null;
      }
    } catch (e) {
      print('Error linking order and transaction: $e');
      return null;
    }
  }

  // Method to get the transaction by order ID
  Future<Map<String, dynamic>?> getTransactionByOrderId(String orderID) async {
    try {
      // Query to get the transaction related to a specific order
      QuerySnapshot querySnapshot = await _firestore
          .collection('transactions')
          .where('orderId', isEqualTo: orderID)
          .get();

      // Return the first transaction (assuming one transaction per order)
      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        return {
          "id": doc.id, // Document ID
          "transaction": UserTransactionRecordsModel.fromMap(doc.data() as Map<String, dynamic>) // TransactionModel object
        };
      } else {
        print('No transaction found for order ID: $orderID');
        return null;
      }
    } catch (e) {
      print('Error fetching transaction by Order ID: $e');
      return null;
    }
  }

  // Method to update a transaction by its ID
  Future<void> updateTransaction(String transactionID, UserTransactionRecordsModel updatedTransaction) async {
    try {
      // Update the transaction in Firestore by its document ID
      await _firestore.collection('transactions').doc(transactionID).update(updatedTransaction.toMap());
      print('Transaction updated successfully');
    } catch (e) {
      print('Error updating transaction: $e');
    }
  }

  // Method to delete a transaction by its ID
  Future<void> deleteTransaction(String transactionID) async {
    try {
      // Delete the transaction from Firestore by its document ID
      await _firestore.collection('transactions').doc(transactionID).delete();
      print('Transaction deleted successfully');
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }
}
