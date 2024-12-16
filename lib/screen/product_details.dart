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
  final List<String> addons; // Add-ons passed to the widget

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final List<String> selectedAddons = []; // Keep track of selected add-ons

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
                    fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold),
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
                  // Render checkboxes for add-ons
                  ...widget.addons.map((addon) {
                    return CheckboxListTile(
                      title: Text(addon, style: CustomStyle.subtitle),
                      value: selectedAddons.contains(addon),
                      onChanged: (isChecked) {
                        setState(() {
                          if (isChecked == true) {
                            selectedAddons.add(addon);
                          } else {
                            selectedAddons.remove(addon);
                          }
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fixedSize: Size(MediaQuery.sizeOf(context).width*0.8, 50)
              ),
              child: const Text("Add to Cart",style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
