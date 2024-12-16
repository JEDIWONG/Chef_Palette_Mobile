import 'package:chef_palette/component/address_selector.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Checkout extends StatelessWidget{

  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(title: "Menu", first: false),
        leadingWidth: MediaQuery.sizeOf(context).width*0.3,
        bottom: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Review and Pay",style: CustomStyle.h1,),
        ),
      ),
      body:  SingleChildScrollView(
        child: Column(

          children: [
            AddressSelector(addr: "Nasi Lemak Bamboo (Samarahan)", hour: "7 AM - 8 PM"),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 20,
              endIndent: 30,
            ),
            OrderSummary(),
          ],
          
        ),
      ),
    );
  }
  
}

class OrderSummary extends StatelessWidget{
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Summary",style: CustomStyle.h2,)
        ],
      ),
    ); 
  }

}