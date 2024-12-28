import 'package:chef_palette/component/address_selector.dart';
import 'package:chef_palette/component/cart_item.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/models/cart_item_model.dart';
import 'package:chef_palette/screen/checkout.dart';
import 'package:chef_palette/services/firestore_services.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartItemModel> cartItems = []; // Holds cart items
  bool isCartEmpty = true; // Tracks whether the cart is empty

  @override
  void initState() {
    super.initState();
    loadCartItems(); // Load initial cart items
  }

  Future<void> loadCartItems() async {
    final items = await FirestoreService().getCartItems();
    setState(() {
      cartItems = items;
      isCartEmpty = cartItems.isEmpty;
    });
  }

  void handleItemRemoved(String itemId) {
    setState(() {
      cartItems.removeWhere((item) => item.itemId == itemId);
      isCartEmpty = cartItems.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
        leading: const CustomBackButton(
          title: 'Menu',
          first: false,
        ),
        title: Text(
          "Cart",
          style: CustomStyle.h1,
        ),
      ),
      bottomSheet: RectButton(
        bg: isCartEmpty ? Colors.grey : Colors.green, // Disable button if cart is empty
        fg: Colors.white,
        text: "Pay Now",
        func: isCartEmpty
            ? () {} // Do nothing if the cart is empty
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Checkout()),
                );
              },
        rad: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressSelector(
              addr: "Nasi Lemak Bamboo (Samarahan)", 
              hour: "7AM-8PM"
            ),
            if (cartItems.isEmpty)
              const Center(child: Text("Your cart is empty")),
            if (cartItems.isNotEmpty)
              Column(
                children: cartItems.map((item) {
                  return CartItem(
                    imgUrl: item.imageUrl,
                    title: item.name,
                    quantity: item.quantity,
                    price: item.price,
                    itemId: item.itemId,
                    onItemRemoved: handleItemRemoved, // Pass callback
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}


