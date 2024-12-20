import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Order extends StatelessWidget{
  const Order({super.key});

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
          first: true,
        ),
        
        title: Text(
          "Orders",
          style: CustomStyle.h1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
  
}