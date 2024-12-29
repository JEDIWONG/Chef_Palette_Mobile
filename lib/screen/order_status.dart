import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/controller/order_controller.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({super.key, required this.orderId});
  
  final String orderId;

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  late Future<Map<String, dynamic>?> orderFuture;

  // Current status step, default to the first status (Pending)
  int currentStep = 1; 

  // Order statuses
  final List<String> statuses = ["Pending", "Preparing", "Serving", "Complete"];

  
  // Initialize the order future in initState
  @override
  void initState() {
    super.initState();
    orderFuture = OrderController().getOrderById(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.grey,
        automaticallyImplyLeading: false,
        title: Text(
          "Order Status",
          style: CustomStyle.h1,
        ),
        leading: const CustomBackButton(title: "Menu", first: false),
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
            // Extract the order details
            final order = snapshot.data!["order"];
            final status = order.status; // Assuming status is available in the order object

            // Set the currentStep based on the order status
            currentStep = statuses.indexOf(status) + 1;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Progress Bar
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 50.0),
                  child: LinearProgressBar(
                    maxSteps: statuses.length, // Total number of statuses
                    progressType: LinearProgressBar.progressTypeDots,
                    currentStep: currentStep, // Current status step
                    progressColor: Colors.green, // Progress bar color
                    backgroundColor: Colors.grey[300]!,
                    dotsAxis: Axis.horizontal,
                    dotsActiveSize: 20,
                    dotsInactiveSize: 10,
                    dotsSpacing: const EdgeInsets.symmetric(horizontal: 20),
                    semanticsLabel: "Order Status",
                    semanticsValue: statuses[currentStep - 1], // Current status label
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 20),

                // Current Status Text
                Text(
                  statuses[currentStep - 1],
                  style: CustomStyle.h3,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
