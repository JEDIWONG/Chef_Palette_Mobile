import 'package:chef_palette/component/product_card.dart';
import 'package:chef_palette/data/product_data.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import '../component/search.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 150,
        title: const Search(),
        centerTitle: true,
        elevation: 3.0,
        shadowColor: Colors.black,
        backgroundColor: CustomStyle.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, 
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                childAspectRatio: 2/1.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  obj: product,
                  imgUrl: product.imgUrl,
                  name: product.name,
                  price: product.price,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
