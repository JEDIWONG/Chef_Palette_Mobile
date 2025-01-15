import 'dart:async';
import 'package:accordion/accordion.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/discount_selector.dart';
import 'package:chef_palette/component/order_item.dart';
import 'package:chef_palette/component/payment_selector.dart';
import 'package:chef_palette/controller/cart_controller.dart';
import 'package:chef_palette/controller/dine_in_controller.dart';
import 'package:chef_palette/controller/order_controller.dart';
import 'package:chef_palette/controller/pickup_controller.dart';
import 'package:chef_palette/controller/user_rewards_controller.dart';
import 'package:chef_palette/data/product_data.dart';
import 'package:chef_palette/index.dart' as cf;
import 'package:chef_palette/models/cart_item_model.dart';
import 'package:chef_palette/models/dine_in_model.dart';
import 'package:chef_palette/models/order_model.dart';
import 'package:chef_palette/models/pickup_model.dart';
import 'package:chef_palette/services/firestore_services.dart'; 
import 'package:chef_palette/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});
  
  @override
  State <Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final ScrollController _scrollController = ScrollController();
  List<bool> isSelected = [true, false, false];
  double processingFee = 0.0; 
  String paymentMethod = "Select a Payment method";
  String branchName = ""; 
  List <String> orderTypes = ["Dine-In", "Pickup", "Delivery"];
  String orderType = "Dine-In";
  
  final user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  final TextEditingController tableNumberController = TextEditingController(); // Controller for table number

  Future<void> fetchBranchName() async {
    final DocumentSnapshot branchSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    setState(() {
      branchName = branchSnapshot['branchLocation'];
    });
  }

  double discountRate = 0.0;

  @override
  void initState() {
    super.initState();
    fetchBranchName();
  }

  void updateOrderType(int index) {
    setState(() {
      orderType = orderTypes[index];
    });
  }

  void updateProcessingFee() {
    setState(() {
      if (isSelected[2]) {
        processingFee = 5.0; 
      } else {
        processingFee = 0.0; 
      }
    });
  }

  Future<double> calculateTotalPrice() async {
    double subPrice = await calculateSubPrice(); 
    double tax = await calculateTax(); 
    double discountAmount = subPrice * discountRate; 
    return (subPrice - discountAmount) + tax + processingFee;
  }

  Future<double> calculateDiscountAmount() async {
    double subPrice = await calculateSubPrice(); 
    double discountAmount = subPrice * discountRate;
    return discountAmount;
  }

  void handleDiscountSelected(double rate) {
    setState(() {
      discountRate = rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.green,
        backgroundColor: Colors.white,
        leading: const CustomBackButton(title: "Cart", first: false),
        leadingWidth: MediaQuery.sizeOf(context).width * 0.3,
        bottom: AppBar(
          surfaceTintColor: Colors.green,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Review and Pay",
            style: CustomStyle.h1,
          ),
        ),
      ),
      bottomNavigationBar: RectButton(
        bg: Colors.green,
        fg: Colors.white,
        text: "Place Order",
        func: () async {
          try {
            OrderController orderController = OrderController();
            CartController cartController = CartController();
            UserRewardsController rewardsController = UserRewardsController();
            DineInOrderController dineInOrderController = DineInOrderController(); // DineIn controller
            PickupOrderController pickupOrderController = PickupOrderController();

            double totalPrice = await calculateTotalPrice(); 
            List<CartItemModel> cartItems = await fetchCartItems();

            int pointsToAdd = totalPrice.floor();

            await cartController.deleteAllCartItems();

            // Check if orderType is "Dine-In" and create DineIn order
            if (orderType == "Dine-In") {
              await dineInOrderController.createDineInOrder(
                DineInOrderModel(
                  paymentMethod: paymentMethod,
                  timestamp: DateTime.now(),
                  userID: user!.uid,
                  branchName: branchName,
                  orderItems: cartItems,
                  price: totalPrice,
                  status: 'Pending',
                  orderType: orderType,
                  tableNumber: tableNumberController.text,
                ),
              );
            } 
            // Check if orderType is "Pickup" and create Pickup order
           else if (orderType == "Pickup") {
              // Generate a random number for the pickup number
              String pickupNo = 'RKI-${DateTime.now().millisecondsSinceEpoch}';

              await pickupOrderController.createPickupOrder(
                PickupOrderModel(
                  paymentMethod: paymentMethod,
                  timestamp: DateTime.now(),
                  userID: user!.uid,
                  branchName: branchName,
                  orderItems: cartItems,
                  price: totalPrice,
                  status: 'Pending',
                  orderType: orderType,
                  pickupNo: pickupNo,
                ),
              );
            }

            else {
              // Otherwise create a general order (Pickup/Delivery)
              await orderController.createOrder(
                OrderModel(
                  paymentMethod: paymentMethod,
                  timestamp: DateTime.now(),
                  userID: user!.uid,
                  branchName: branchName,
                  orderItems: cartItems,
                  price: totalPrice,
                  status: 'Pending',
                  orderType: orderType,
                ),
              );
            }

            await rewardsController.addPoints(user!.uid, pointsToAdd);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const cf.Index(initIndex: 1)),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order placed successfully! $pointsToAdd points added to your account.')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to place order: $e')),
            );
          }
        },
        rad: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.symmetric(vertical: 30),
              alignment: Alignment.center,
              child: ToggleButtons(
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                  updateOrderType(index);
                  updateProcessingFee();
                },
                borderRadius: BorderRadius.circular(10),
                textStyle: const TextStyle(fontSize: 14),
                selectedColor: Colors.white,
                fillColor: Colors.green,
                color: Colors.black,
                borderWidth: 1,
                borderColor: Colors.green,
                selectedBorderColor: Colors.green,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                    child: Text("Dine-In"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    child: Text("Pickup"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    child: Text("Delivery"),
                  ),
                ],
              ),
            ),

            // Show the relevant UI based on selected order type
            if (orderType == "Dine-In") 
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: tableNumberController,
                  decoration: InputDecoration(
                    labelText: 'Enter Table Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            if (orderType == "Delivery") 
              Container(
                child: Text("Placeholder"),
              ),

            OrderSummary(processingFee: processingFee, branchName: branchName, orderType: orderType, discountRate: discountRate),

            TotalPriceBar(discountRate: discountRate),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                spacing: 20,
                children: [
                  PaymentSelector(
                    current: paymentMethod,
                    onPaymentMethodSelected: (String s) { 
                      setState(() {
                        paymentMethod = s;
                      });
                    },
                  ),
                  DiscountSelector(
                    onDiscountSelected: handleDiscountSelected,
                    current: discountRate,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class OrderSummary extends StatelessWidget {
  const OrderSummary({
    super.key,
    required this.processingFee,
    required this.branchName,
    required this.orderType,
    required this.discountRate,
  });

  final double processingFee;
  final String branchName;
  final String orderType;
  final double discountRate;

  // Async method for fetching processing fee
  Future<double> calculateProcessingFee() async {
    return Future.value(processingFee); // You can modify this to get processing fee from an API or logic
  }

  Future<double> calculateDiscountAmount() async {
    // First, calculate the subtotal
    double subprice = await calculateSubPrice();

    // Calculate the discount amount
    double discountAmount = subprice * discountRate;

    // Return the calculated discount amount
    return discountAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Accordion(
            disableScrolling: true,
            paddingBetweenClosedSections: 50,
            children: [
              AccordionSection(
                isOpen: false,
                headerBackgroundColor: Colors.green,
                contentBorderColor: Colors.green,
                headerPadding: const EdgeInsets.all(10),
                header: Text("Branch Selected", style: CustomStyle.lightH4),
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(branchName, style: CustomStyle.txt),
                ),
              ),
              AccordionSection(
                isOpen: true,
                headerBackgroundColor: Colors.green,
                contentBorderColor: Colors.green,
                headerPadding: const EdgeInsets.all(10),
                header: Text("Order Summary", style: CustomStyle.lightH4),
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: FutureBuilder<List<CartItemModel>>(
                    future: fetchCartItems(), // Fetch cart items here
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("Your cart is empty"));
                      } else {
                        return Column(
                          children: snapshot.data!.map((cartItem) {
                            return OrderItem(
                              name: cartItem.name,
                              quantity: cartItem.quantity,
                              price: cartItem.price,
                              addons: cartItem.addons,
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ),
              AccordionSection(
                headerBackgroundColor: Colors.green,
                contentBorderColor: Colors.green,
                headerPadding: const EdgeInsets.all(10),
                header: Text("Price Details", style: CustomStyle.lightH4),
                content: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Async breakdown price calculations for Subtotal and Tax
                      const BreakdownPrice(name: "Subtotal", func: calculateSubPrice),
                      const BreakdownPrice(name: "Tax", func: calculateTax),
                      
                      // Use FutureBuilder for processing fee
                      FutureBuilder<double>(
                        future: calculateProcessingFee(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Loading state
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          return BreakdownPrice(
                            name: "Processing Fees",
                            func: () async => snapshot.data ?? 0.0,
                          );
                        },
                      ),
                      
                      // Use FutureBuilder for discount amount
                      FutureBuilder<double>(
                        future: calculateDiscountAmount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Loading state
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          return ListTile(
                            title: Text("Discount :"),
                            trailing: Text("RM ${snapshot.data?.toStringAsFixed(2) ?? '0.00'}"),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class TotalPriceBar extends StatelessWidget {
  final double discountRate;
  const TotalPriceBar({super.key, required this.discountRate});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.green,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(1, 1),
            blurRadius: 1,
            blurStyle: BlurStyle.normal,
          )
        ]
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        leading: Text("Total", style: CustomStyle.h3),
        trailing: FutureBuilder<double>(
          future: calculateTotalPrice(discountRate), 
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              return Text("RM ${snapshot.data!.toStringAsFixed(2)}", style: CustomStyle.h2);
            } else {
              return const Text("RM 0.00");
            }
          },
        ),
      ),
    );
  }

  Future<double> calculateTotalPrice(double discountRate) async {
    double subPrice = await calculateSubPrice(); // Calculate the subtotal
    double tax = await calculateTax(); // Calculate the tax
    
    double discountAmount = subPrice * discountRate; // Calculate discount based on discountRate

    return (subPrice - discountAmount) + tax + 0.0; // Add processing fee if necessary
  }
}


class BreakdownPrice extends StatelessWidget{
  const BreakdownPrice({super.key, required this.name, required this.func});

  final String name;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      
      leading: Text("$name : ", style: CustomStyle.txt),
      trailing: FutureBuilder<double>(
        future: func(), 
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            return Text("RM ${snapshot.data!.toStringAsFixed(2)}"); 
          } else {
            return const Text("RM 0.00");
          }
        },
      ),
    );
  }
  
}

Future<List<CartItemModel>> fetchCartItems() async {

    FirestoreService firestoreService = FirestoreService();
    return await firestoreService.getCartItems();
  }

Future <double> calculateSubPrice() async {
  
  List<CartItemModel> cartItems = await fetchCartItems();

  double subPrice = 0.0;
  
  for (CartItemModel item in cartItems) {
    subPrice += item.price * item.quantity; 
  }

  return subPrice.toDouble();
}

Future <double> calculateTax() async {
  
  double subPrice = await calculateSubPrice();

  double taxRate = 0.16;

  double tax  = subPrice*taxRate;

  return tax;
}

Future <double> calculateTotalPrice() async {
  
  double subPrice = await calculateSubPrice();
  double tax = await calculateTax();

  double total  = subPrice+tax;

  return total;
}