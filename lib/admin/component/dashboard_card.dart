import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget{
  const DashboardCard({super.key, required this.target, required this.title, required this.iconUrl});

  final Widget target;
  final String title;
  final String iconUrl;


  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>target)); 
        },
        child: Container(
          
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                spreadRadius: 0.5,
                color: Colors.green,
                blurRadius: 0.5,
                blurStyle: BlurStyle.normal,
              )
            ]
          ),
          child: ListTile(
            title: const Image(
                image: AssetImage("assets/images/test.png"),
                height: 100,
              ),
            subtitle: Text(title,style: const TextStyle(fontSize: 14,fontWeight:FontWeight.bold),),
          )
        ),
    );
  }
  
}