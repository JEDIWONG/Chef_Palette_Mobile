import 'package:chef_palette/models/product.model.dart';
import 'package:chef_palette/screen/product_details.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget{
  const ProductCard({super.key, required this.imgUrl, required this.name, required this.price, required this.obj});

  final ProductModel obj; 
  final String imgUrl;
  final String name; 
  final double price;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("wtf");
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetails(name: name, imgUrl: imgUrl, price: price, desc: obj.desc, addons: obj.addons, option: obj.options,)));
      },

      child: Container(
        width: MediaQuery.sizeOf(context).width*0.4,
        height: MediaQuery.sizeOf(context).width*0.4,

        child:  Column(
          
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset(
                imgUrl,
                
              
                fit: BoxFit.cover,
              ),
            ),
            
            
            ListTile(
              title: Text(name,style: CustomStyle.h2,),
              subtitle: Text("RM ${price.toStringAsFixed(2)}",style: const TextStyle(fontSize: 18,color: Colors.green,fontWeight: FontWeight.bold),),
            )
            
            
          ],
        ),
      ),
      
    );
  }
  
}