import 'package:flutter/material.dart';

class RewardTile extends StatelessWidget{
  const RewardTile({super.key, required this.name, required this.type, required this.expiryDate, required this.rewardId});

  final String name;
  final String type;
  final String expiryDate;
  final String rewardId;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},

      child: Card(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: ListTile(
          textColor: Colors.white,
          trailing: Icon(Icons.navigate_next_rounded,color: Colors.white,),
          title: Text(name),
          subtitle: Column(
            children: [
              Text(type),
              Text(expiryDate)
            ],
          ),
        )
      ),
    );
  }
  
}