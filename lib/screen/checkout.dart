import 'package:chef_palette/component/address_selector.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/models/cart_item_model.dart';
import 'package:chef_palette/services/firestore_services.dart'; // Assuming this fetches cart data
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(title: "Menu", first: false),
        leadingWidth: MediaQuery.sizeOf(context).width * 0.3,
        bottom: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Review and Pay",
            style: CustomStyle.h1,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            AddressSelector(
                addr: "Nasi Lemak Bamboo (Samarahan)", hour: "7 AM - 8 PM"),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 20,
              endIndent: 30,
            ),
            OrderSummary(),

            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 20,
              endIndent: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  Future<List<CartItemModel>> fetchCartItems() async {

    FirestoreService firestoreService = FirestoreService();
    return await firestoreService.getCartItems();
  }

  Future <double> calculateTotalPrice() async {
    
    List<CartItemModel> cartItems = await fetchCartItems();

    double totalPrice = 0.0;
    
    for (CartItemModel item in cartItems) {
      totalPrice += item.price * item.quantity; 
    }

    return totalPrice.toDouble();
  }

  Future <double> calculateTax() async {
    
    List<CartItemModel> cartItems = await fetchCartItems();

    double totalPrice = 0.0;
    
    for (CartItemModel item in cartItems) {
      totalPrice += item.price * item.quantity; 
    }

    return totalPrice.toDouble();
  }
  


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Summary", style: CustomStyle.h2),

          Padding(
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

          ListTile(
            leading: Text("Subtotal : ", style: CustomStyle.txt),
            trailing: FutureBuilder<double>(
              future: calculateTotalPrice(), // Call the asynchronous function
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  return Text("RM ${snapshot.data!.toStringAsFixed(2)}"); // Display total price
                } else {
                  return const Text("RM 0.00");
                }
              },
            ),
          )

        ],
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem(
      {super.key, required this.name, required this.price, required this.quantity});

  final String name;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("$quantity x"),
      title: Text(name),
      trailing: Text("RM ${price.toStringAsFixed(2)}"),
    );
  }
}
