import 'package:accordion/accordion.dart';
import 'package:chef_palette/component/loading_progress_bar.dart';
import 'package:chef_palette/component/order_item.dart';
import 'package:chef_palette/models/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/controller/order_controller.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/style/style.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({super.key, required this.orderId, required this.orderType});
  
  final String orderId;
  final String orderType;

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  late Future<Map<String, dynamic>?> orderFuture;
  int currentStep = 0; 

  final List<String> statuses = ["Pending", "Preparing", "Serving", "Complete"];
  final List<String> statusDesc = ["We're Confirming Your Order", "Our Kitchen Is Preparing Your Order", "Your Food Is On The Way", "Order Served. Thanks For Ordering"];

  @override
  void initState() {
    super.initState();
    // Fetch the order by ID using the order controller
    orderFuture = OrderController().getOrderById(widget.orderId);
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
        future: orderFuture, // Use the orderFuture here
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
            final status = order.status;

            // Set the currentStep based on the order status
            currentStep = statuses.indexOf(status);

            // Now you can fetch the order items from the 'order' object
            final orderItems = order.orderItems;

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
                      semanticsValue: statuses[currentStep],
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
                    title: Text(statuses[currentStep], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),),
                    subtitle: Text(statusDesc[currentStep], style: CustomStyle.subtitle,),
                    trailing: const Icon(Icons.dining_rounded, color: Colors.green,),
                  ),
                  
                  // Progress Bar
                  const LoadingProgressBar(isComplete: false),
                  
                  const SizedBox(height: 20),

                  // Conditionally render table number for Dine-in orders
                  if (order.orderType == "Dine-In") 
                    ListTile(
                      title: Text("Table Number : "),
                      trailing: Text(order.tableNumber),  // Fetch Table Number from Firebase
                    ),
                  
                  // Conditionally render pickup number for Pickup orders
                  if (order.orderType == "Pickup")
                    ListTile(
                      title: Text("Pickup Number : "),
                      trailing: Text(order.pickupNo),  // Fetch Pickup Number from Firebase
                    ),

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