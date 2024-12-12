import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget{

  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child:IconButton(onPressed: (){}, icon: const Icon(Icons.edit)),
          ), 

          Row(
            children: [
              const Icon(Icons.account_circle_rounded,size: 50,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                
                child: Column(
                  children: [
                    Text("John Doe",textAlign: TextAlign.left,style: CustomStyle.h1,),
                    Text("Registered since 12 Nov 2024",textAlign: TextAlign.left,style: CustomStyle.txt,),
                  ],
                ),
              )
            ],
           
          ), 

          Container(
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                ListTile(title: Text("Contact Information",style: CustomStyle.h4,textAlign: TextAlign.left,),), 
                const ListTile(leading: Text("Email"),title: Text("JohnDoe@gmail.com"),),
                const ListTile(leading: Text("Phone"),title: Text("011-12312345"),),
              ],
            ),
          )
        
        ],
      ),
    );
  }


}