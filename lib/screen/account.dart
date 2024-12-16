import 'package:chef_palette/auth/auth.dart';
import 'package:chef_palette/component/account_card.dart';
import 'package:chef_palette/component/account_setting.dart';
import 'package:chef_palette/style/style.dart';
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
            ListTile(title: Text("Features",style: CustomStyle.h3,),),
            const AccountTile(title: "Transaction History", icon: Icons.receipt),
            const AccountTile(title: "Location", icon: Icons.location_city),
            const AccountTile(title: "Payment Method", icon: Icons.payment_rounded),
            const AccountSetting(),

            const SizedBox(height: 30,),
            OutlinedButton(
              
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Auth()));
              }, 
              style: OutlinedButton.styleFrom(
              
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
                fixedSize: Size(MediaQuery.sizeOf(context).width-80, 50),
              ),
              child:const Text("Sign Out")
            )
          ],
        ),
      )
    );
  }
}


class AccountTile extends StatelessWidget{
  const AccountTile({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
      },
      splashColor: Colors.green,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title,style: CustomStyle.txt,),
        trailing: const Icon(Icons.navigate_next_rounded),
      ),
    );
  }

}