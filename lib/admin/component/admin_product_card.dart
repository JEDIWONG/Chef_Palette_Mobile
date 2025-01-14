import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AdminProductCard extends StatelessWidget{
  const AdminProductCard({super.key, required this.productID, required this.imgUrl, required this.name, required this.price});

  final String productID;
  final String imgUrl;
  final String name; 
  final double price;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       // Navigator.push(context, MaterialPageRoute(builder: (context)=>));
      },
      child: ListTile(
      
       leading: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            imgUrl,
            fit: BoxFit.fill,
            width: MediaQuery.sizeOf(context).width*0.3,
            height: 400,
          ),
        ),
       title: Text(name,style: CustomStyle.h4,),
       subtitle: Text("RM ${price.toStringAsFixed(2)}",style: TextStyle(color: Colors.green),),       
       trailing: Icon(Icons.navigate_next_rounded,),
      ),
    );
  }
  
}