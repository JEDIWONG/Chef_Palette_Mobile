import 'package:chef_palette/screen/order_status.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';


class OrderCard extends StatelessWidget{
  const OrderCard({super.key, required this.orderId, required this.status, required this.datetime, });

  final String orderId;
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
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderStatus(orderId: orderId,)));
      },

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