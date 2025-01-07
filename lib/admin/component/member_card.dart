import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget{
  const MemberCard({super.key, required this.memberId, required this.joinDate});

  final String memberId; 
  final String joinDate; 

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
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
            title: Text("Id: $memberId",style: const TextStyle(fontSize: 14,fontWeight:FontWeight.bold),),
            subtitle: Text("Joined$joinDate",style: const TextStyle(fontSize: 14,fontWeight:FontWeight.bold),),
            trailing: const Icon(Icons.navigate_next_rounded),
          )
        ),
    );
  }
  
}