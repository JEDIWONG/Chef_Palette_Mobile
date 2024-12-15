import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget{
  const ProductCard({super.key, required this.imgUrl, required this.name, required this.price});

  final String imgUrl;
  final String name; 
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width*0.4,

      child:  Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.asset(
              imgUrl,
              
              height: MediaQuery.sizeOf(context).width*0.4, 
              fit: BoxFit.cover,
            ),
          ),
          
          ListTile(
            title: Text(name,style: CustomStyle.h2,),
            subtitle: Text("RM ${price.toStringAsFixed(2)}",style: const TextStyle(fontSize: 18,color: Colors.green,fontWeight: FontWeight.bold),),
          )
          
          
        ],
      ),
    ); 
  }
  
}