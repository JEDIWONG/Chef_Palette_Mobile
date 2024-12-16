import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    super.key,
    required this.name,
    required this.imgUrl,
    required this.price,
    required this.desc,
    required this.addons,
  });

  final String name;
  final String imgUrl;
  final double price;
  final String desc;
  final List<Map<String, dynamic>> addons; // Add-ons with prices

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final List<Map<String, dynamic>> selectedAddons = []; // Track selected add-ons
  double totalPrice = 0.0; // To store the total price
  int quantity = 1;
  
  @override
  void initState() {
    super.initState();
    totalPrice = widget.price; // Initialize total price with base price
  }

  void _updateTotalPrice() {
    totalPrice = (widget.price +
        selectedAddons.fold(
          0.0,
          (sum, addon) => sum + addon["price"],
        ))*quantity;
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: MediaQuery.sizeOf(context).width * 0.3,
        leading: const CustomBackButton(title: "Menu"),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        
        
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Image.asset(widget.imgUrl),
            ListTile(
              title: Text(widget.name, style: CustomStyle.h2),
              subtitle: Text(widget.desc, style: CustomStyle.subtitle),
              trailing: Text(
                "RM ${widget.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add-ons", style: CustomStyle.h2),
                  const SizedBox(height: 10),
                  ...widget.addons.map((addon) {
                    return CheckboxListTile(
                      title: Text(
                        "${addon['name']} (RM ${addon['price'].toStringAsFixed(2)})",
                        style: CustomStyle.subtitle,
                      ),
                      value: selectedAddons.contains(addon),
                      onChanged: (isChecked) {
                        setState(() {
                          if (isChecked == true) {
                            selectedAddons.add(addon);
                          } else {
                            selectedAddons.remove(addon);
                          }
                          _updateTotalPrice();
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Quantity", style: CustomStyle.h2),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                              _updateTotalPrice();
                            }
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      ),
                      Text(quantity.toString(), style: CustomStyle.h2),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                            _updateTotalPrice();
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            
            ElevatedButton(
              onPressed: () {
                // Show the final price with add-ons in a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Added to Cart: RM ${totalPrice.toStringAsFixed(2)} - Add-ons: ${selectedAddons.map((e) => e['name']).join(', ')}",
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fixedSize: Size(MediaQuery.sizeOf(context).width * 0.8, 50),
              ),
              child: Text(
                "Add to Cart ${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

