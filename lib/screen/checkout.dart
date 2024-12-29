import 'dart:async';
import 'package:accordion/accordion.dart';
import 'package:chef_palette/component/address_selector.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/discount_selector.dart';
import 'package:chef_palette/component/order_item.dart';
import 'package:chef_palette/component/payment_selector.dart';
import 'package:chef_palette/controller/cart_controller.dart';
import 'package:chef_palette/controller/order_controller.dart';
import 'package:chef_palette/index.dart';
import 'package:chef_palette/models/cart_item_model.dart';
import 'package:chef_palette/models/order_model.dart';
import 'package:chef_palette/services/firestore_services.dart'; 
import 'package:chef_palette/style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Checkout extends StatefulWidget{
  const Checkout({super.key});
  
  @override
  State <Checkout> createState() => _CheckoutState();
   
}

class _CheckoutState extends State<Checkout> {

  final ScrollController _scrollController = ScrollController();
  
  List<bool> isSelected = [true, false, false];

  double processingFee = 0.0; 
  
  String paymentMethod = "Select a Payment method";
  String branchName = "Nasi Lemak Bamboo (Samarahan)";
  double discountRate = 0.0;

  final user  = FirebaseAuth.instance.currentUser;

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
    return subPrice + tax + processingFee;
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
        func: () async{

          OrderController orderController = OrderController();
          CartController cartController = CartController();

          double totalPrice = await calculateTotalPrice(); 
          List<CartItemModel> cartItems = await fetchCartItems(); 

          await cartController.deleteAllCartItems();

          await orderController.createOrder(
            OrderModel(
              paymentMethod: paymentMethod,
              timestamp: DateTime.now(),  
              userID: user!.uid,          
              branchName: branchName,
              orderItems: cartItems,      
              price: totalPrice,          
              status: 'Pending',          
            ),
          );

          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Index(initIndex: 1,))); 
        }, 
        rad: 0,   
      ),

      body:  SingleChildScrollView(
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
                  updateProcessingFee(); // Update processing fee based on the selected option
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
                    child: Text("PickUp"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    child: Text("Delivery"),
                  ),
                ],
              ),
            ),

            const AddressSelector(
              addr: "Nasi Lemak Bamboo (Samarahan)",
              hour: "7 AM - 8 PM",
            ),
            
            
            OrderSummary(processingFee: processingFee,),

            const TotalPriceBar(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
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
                    onDiscountSelected: (double d){
                      setState(() {
                        discountRate = d;
                      });
                    },
                    current: discountRate,
                  )
                ],
              )
            ),

          ],
        ),
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key, required this.processingFee});

  final double processingFee; 

  Future<double> calculateProcessingFee() async {
    
    return Future.value(processingFee); 
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
                  margin:const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const BreakdownPrice(name: "Subtotal", func: calculateSubPrice),
                      const BreakdownPrice(name: "Tax", func: calculateTax),
                      BreakdownPrice(name: "Processing Fees", func: calculateProcessingFee),
                    ],
                  ),
                )
              ),
            ]
          
          ),
    
        ],
      ),
    );
  }
}

class TotalPriceBar extends StatelessWidget{
  const TotalPriceBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration:  BoxDecoration(
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
        contentPadding: const EdgeInsets.symmetric(vertical:0,horizontal: 20),
        leading:  Text("Total", style: CustomStyle.h3),
        trailing: FutureBuilder<double>(
          future: calculateTotalPrice(), 
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else if (snapshot.hasData) {
              return Text("RM ${snapshot.data!.toStringAsFixed(2)}",style: CustomStyle.h2,);
            } else {
              return const Text("RM 0.00");
            }
          },
        ),
      ),
    );
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




