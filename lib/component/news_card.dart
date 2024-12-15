import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget{
  const NewsCard({super.key, required this.title, required this.desc, required this.date});

  final String title; 
  final String desc; 
  final String date;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
            style: BorderStyle.solid,
          )
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 100,
        children: [
          const Icon(Icons.mail_rounded),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: CustomStyle.h2,
              ),
              Text(
                date,
                style: CustomStyle.txt,
              ),
            ],
          ),
        ],
      ),
    );
  }

  
}