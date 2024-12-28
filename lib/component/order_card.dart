import 'package:chef_palette/models/cart_item_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';


class OrderCard extends StatelessWidget{
  const OrderCard({super.key, required this.orderItems, required this.status, required this.datetime});

  final List <CartItemModel> orderItems;
  final String status;
  final DateTime datetime; 

  convertDate(){
    String s;

    s = "${datetime.year}-${datetime.month}-${datetime.day}";

    return s;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},

      child: Card(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 
        ),
        child: ListTile(
          title: Text(status,style: CustomStyle.lightH3,),
          subtitle: Text("Created On ${convertDate()}",style: CustomStyle.lightTxt,),
          trailing: const Icon(Icons.navigate_next,color: Colors.white,),
        )
      ),
    );
  }
  
}