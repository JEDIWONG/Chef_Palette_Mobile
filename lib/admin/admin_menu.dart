import "package:chef_palette/admin/admin_add_menu.dart";
import "package:chef_palette/admin/component/admin_product_card.dart";
import "package:chef_palette/component/custom_button.dart";
import 'package:chef_palette/controller/product_controller.dart';
import "package:chef_palette/style/style.dart";
import "package:flutter/material.dart";

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = ProductController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Manage Menu",
          style: CustomStyle.h3,
        ),
        leading: const CustomBackButton(title: "Back", first: false),
        leadingWidth: MediaQuery.sizeOf(context).width*0.3,
      ),
      bottomSheet: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          fixedSize: Size(MediaQuery.sizeOf(context).width, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminAddMenu()),
          );
        },
        child: const Text("Add Menu"),
      ),
      body: FutureBuilder(
        future: productController.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return SingleChildScrollView(
              padding: EdgeInsets.only(top: 50,bottom: 100),
              child: Column(
                spacing: 10,
                children: productController.products.map((product) {
                  return AdminProductCard(
                    productID: product.uid,
                    imgUrl: product.imgUrl,
                    name: product.name,
                    price: product.price,
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
