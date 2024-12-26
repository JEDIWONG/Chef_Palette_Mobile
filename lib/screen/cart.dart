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
  List<bool> isSelected = [true, false, false];
  late Future<List<CartItemModel>> cartItems; // Variable to hold cart items
  
  @override
  void initState() {
    super.initState();
    
    cartItems = FirestoreService().getCartItems();
    
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Toggle buttons for selection
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
                },
                borderRadius: BorderRadius.circular(20),
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
            
            const AddressSelector(addr: "Nasi Lemak Bamboo (Samarahan)", hour: "7AM-8PM"),

            // FutureBuilder to display cart items
            FutureBuilder<List<CartItemModel>>(
              future: cartItems,  // The Future is directly used here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  
                  return const Center(child: CircularProgressIndicator());

                } else if (snapshot.hasError) {

                  return Center(child: Text("Error: ${snapshot.error}"));

                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  
                  return const Center(child: Text("Your cart is empty"));
                } else {
                  
                  return Column(
                    children: snapshot.data!.map((c) {
                      return CartItem(
                        imgUrl: c.imageUrl,
                        title: c.name,
                        quantity: c.quantity,
                        price: c.price,
                        itemId: c.itemId, 
                      );
                    }).toList(),
                  );
                }
              },
            ),

            // Pay Now button
            RectButton(
              bg: Colors.green,
              fg: Colors.white,
              text: "Pay Now",
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Checkout()),
                );
              },
              rad: 0,
            ),
          ],
        ),
      ),
    );
  }

  
}
