import 'package:chef_palette/component/account_card.dart';
import 'package:chef_palette/component/account_setting.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget{
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 50),
        child: Column(
          children: [
            const AccountCard(),
            const AccountSetting(),

            OutlinedButton(
              
              onPressed: (){}, 
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
                fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
              ),
              child:const Text("Sign Out")
            )
          ],
        ),
      )
    );
  }
  
  
}