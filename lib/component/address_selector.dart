import 'package:chef_palette/screen/branch.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AddressSelector extends StatelessWidget{
  const AddressSelector({super.key, required this.addr, required this.hour});

  final String addr; 
  final String hour;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Branch()));
      },
      child: ListTile(
        leading: const Icon(Icons.location_pin,color: Colors.red,),
        title: Text(addr,style: CustomStyle.h4,),
        trailing: Text("Change", style: CustomStyle.link),
        subtitle: Row(
          children: [
            Text("Opening Hour:  $hour",style: CustomStyle.subtitle,),
          ],
        )
      ),
    );
  }
  
}