import 'package:accordion/accordion.dart';
import 'package:chef_palette/component/loading_progress_bar.dart';
import 'package:chef_palette/component/order_item.dart';
import 'package:chef_palette/models/cart_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/controller/order_controller.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/style/style.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:chef_palette/models/receipt_model.dart';

class AdminOrderStatus extends StatefulWidget {
  const AdminOrderStatus({super.key, required this.orderId, required this.orderType});

  final String orderId;
  final String orderType;

  @override
  State<AdminOrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<AdminOrderStatus> {
  late Future<Map<String, dynamic>?> orderFuture;
  int currentStep = 0;

  final List<String> statuses = ["Pending", "Preparing", "Serving", "Complete"];
  final List<String> statusDesc = ["We're Confirming Your Order", "Our Kitchen Is Preparing Your Order", "Your Food Is On The Way", "Order Served. Thanks For Ordering"];

  String currStatus = "";
  String currStatusDesc = "";

  @override
  void initState() {
    super.initState();
    // Fetch the order by ID using the order controller
    orderFuture = OrderController().getOrderById(widget.orderId);
    orderFuture.then((data) {
      if (data != null) {
        final order = data["order"];
        final status = order.status;
        setState(() {
          currentStep = statuses.indexOf(status);
          currStatus = status;
          currStatusDesc = statusDesc[currentStep];
        });
      }
    });
  }

  Future<void> updateOrderStatus(String newStatus) async {
    try {
      // Ensure the order ID and new status are properly passed to the controller
      await OrderController().updateOrderStatus(widget.orderId, newStatus,widget.orderType);
      
      // Update the UI with the new status and its description
      setState(() {
        currentStep = statuses.indexOf(newStatus);
        currStatus = newStatus;
        currStatusDesc = statusDesc[currentStep];
      });

      // Provide feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated to $newStatus')),
      );
    } catch (e) {
      // Handle any errors during the update process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status: $e')),
      );
    }
  }

Future<void> saveReceiptToDatabase(Receipt receipt) async {
  try {
    final db = FirebaseFirestore.instance;
    await db.collection('receipts').add(receipt.toJson());
    debugPrint("Receipt saved successfully!");
  } catch (e) {
    debugPrint("Failed to save receipt: $e");
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.grey,
        automaticallyImplyLeading: false,
        title: Text("Order Status", style: CustomStyle.h2),
        leading: const CustomBackButton(title: "Order", first: false),
        leadingWidth: MediaQuery.sizeOf(context).width * 0.3,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error fetching order: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                "Order not found",
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            // Extract order details from the snapshot data
            final order = snapshot.data!["order"];
            final orderItems = order.orderItems;

            void saveOrderAsReceipt() {
                // Calculate total cost
                double totalCost = orderItems.fold(
                  0,
                  (sum, item) => sum + (item.price * item.quantity),
                );

                // Create the receipt
                Receipt receipt = Receipt(
                  orderId: widget.orderId,
                  items: orderItems,
                  total: totalCost,
                  status: currStatus,

                );

                // Save receipt to database
                saveReceiptToDatabase(receipt);
              }


            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30,),

                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: LinearProgressBar(
                      maxSteps: statuses.length,
                      progressType: LinearProgressBar.progressTypeDots,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      currentStep: currentStep,
                      progressColor: Colors.green,
                      backgroundColor: Colors.grey[300]!,
                      dotsAxis: Axis.horizontal,
                      dotsActiveSize: 20,
                      dotsInactiveSize: 15,
                      dotsSpacing: const EdgeInsets.symmetric(horizontal: 20),
                      semanticsLabel: "Order Status",
                      semanticsValue: currStatus,
                      minHeight: 10,
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.location_pin, color: Colors.red,),
                    subtitle: Text("${order.orderType}", style: CustomStyle.subtitle,),
                    title: Text(order.branchName, style: CustomStyle.h4,),
                  ),

                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    title: Text(currStatus, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),),
                    subtitle: Text(currStatusDesc, style: CustomStyle.subtitle,),
                    trailing: const Icon(Icons.dining_rounded, color: Colors.green,),
                  ),

                  const LoadingProgressBar(isComplete: false),

                  const SizedBox(height: 20),

                  Accordion(
                    children: [
                      AccordionSection(
                        isOpen: true,
                        contentBorderColor: Colors.green,
                        headerBackgroundColor: Colors.green,
                        headerPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        rightIcon: const Icon(Icons.arrow_drop_up_rounded, color: Colors.white,),
                        header: Text("Order Summary", style: CustomStyle.lightH3,),
                        content: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: orderItems.map<Widget>((CartItemModel item) {
                              return OrderItem(
                                name: item.name,
                                price: item.price,
                                quantity: item.quantity,
                                addons: item.addons,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ]
                  ),

                  ListTile(
                    tileColor: Colors.green,
                    leading: Text("Order ID: ", style: CustomStyle.h5,),
                    title: Text(widget.orderId, style: CustomStyle.lightTxt,),
                    trailing: const Icon(Icons.copy, color: Colors.white,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: DropdownButton<String>(
                      value: currStatus,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      underline: Container(
                        height: 2,
                        color: Colors.green,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          updateOrderStatus(newValue);
                          if(newValue == "Complete"){
                            saveOrderAsReceipt();
                          }
                        }
                      },
                      items: statuses.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
