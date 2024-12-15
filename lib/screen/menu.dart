import 'package:chef_palette/component/product_card.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import '../component/search.dart';

class Menu extends StatelessWidget{
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
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
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40))
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            ProductCard(imgUrl: "assets/images/placeholder.png", name: "name", price: 12.0),
            ProductCard(imgUrl: "assets/images/placeholder.png", name: "name", price: 12.0),
            ProductCard(imgUrl: "assets/images/placeholder.png", name: "name", price: 12.0),
          ],
        ),
      ),
    );
  }
  
}