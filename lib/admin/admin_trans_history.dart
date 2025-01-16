import 'package:chef_palette/component/order_card.dart';
import 'package:chef_palette/controller/order_controller.dart';
import 'package:chef_palette/controller/user_controller.dart';
import 'package:chef_palette/models/order_model.dart';
import 'package:chef_palette/models/user_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/component/custom_button.dart';

class AdminTransactionHistory extends StatefulWidget {
  const AdminTransactionHistory({super.key});

  @override
  State<AdminTransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<AdminTransactionHistory> {
  final UserController _userController = UserController();
  bool isLoading = true;
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final fetchedUsers = await _userController.fetchUsers(); // Fetch all users
      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (users.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(title: "Account", first: false),
          leadingWidth: MediaQuery.sizeOf(context).width * 0.3,
          title: Text("Transaction Record", style: CustomStyle.h3),
        ),
        body: const Center(
          child: Text(
            "No users found in the database.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const CustomBackButton(title: "Account", first: false),
        leadingWidth: MediaQuery.sizeOf(context).width * 0.3,
        title: Text("Transaction Record", style: CustomStyle.h3),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, userIndex) {
          final user = users[userIndex];
          final userId = user.uid; // Get each user's ID

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: OrderController().getOrdersByUser(userId), // Fetch orders for the user
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return const Center(child: CircularProgressIndicator());
              // }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error fetching orders for ${user.firstName}: ${snapshot.error}",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return ListTile(
                  title: Text(
                    user.firstName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("No orders found for this user."),
                );
              }

              List<Map<String, dynamic>> completedOrdersWithIds = snapshot.data!
                  .where((orderWithId) =>
                      (orderWithId['order'] as OrderModel).status == "Complete")
                  .toList();

              if (completedOrdersWithIds.isEmpty) {
                return ListTile(
                  title: Text(
                    user.firstName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("No completed transactions yet."),
                );
              }

              return ExpansionTile(
                title: Text(
                  user.firstName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Completed Orders: ${completedOrdersWithIds.length}"),
                children: completedOrdersWithIds.map((orderWithId) {
                  final orderId = orderWithId['id'] as String;
                  final order = orderWithId['order'] as OrderModel;

                  return OrderCard(
                    orderId: orderId,
                    status: order.status,
                    datetime: order.timestamp,
                    orderType: order.orderType,
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
