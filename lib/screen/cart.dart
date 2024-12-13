import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Cart extends StatelessWidget{
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: MediaQuery.sizeOf(context).width*0.30,
        leading: CustomBackButton(title: 'Menu',),
        title: Text("Cart",style: CustomStyle.h1,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("data"),
          ],
        ),
      )
    );
  }
  
}