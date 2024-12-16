import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AddressSelector extends StatelessWidget{
  const AddressSelector({super.key, required this.addr, required this.hour});

  final String addr; 
  final String hour;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_pin,color: Colors.red,),
      title: Text(addr,style: CustomStyle.h4,),
      subtitle: Row(
        children: [
          Text("Opening Hour:  $hour",style: CustomStyle.subtitle,),
          const SizedBox(width: 10,),
          Text("Change Location",style: CustomStyle.link,)
        ],
      )
    );
  }

  
}