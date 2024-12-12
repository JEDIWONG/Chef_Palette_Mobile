import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AccountSetting extends StatelessWidget{
  const AccountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: Text("Advanced Setting",style: CustomStyle.h3,),
          ),
          ListTile(

            leading: const Icon(Icons.password_rounded),
            title: Text("Change Password",style: CustomStyle.h4,),
            subtitle: Text("Change Your Password To a New one",style: CustomStyle.subtitle,),
            trailing: ElevatedButton(
              onPressed: (){}, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                fixedSize: Size(100, 30)
              ),
              child: Text("Change"),

            ),
          ),
          ListTile(

            leading: const Icon(Icons.password_rounded),
            title: Text("Terminate Account",style: CustomStyle.h4,),
            subtitle: Text("This account will loss forever",style: CustomStyle.subtitle,),
            trailing: ElevatedButton(
              onPressed: (){}, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                fixedSize: Size(100, 30)
              ),
              child: Text("Delete"),

            ),
          )
        ],
      ),
    );
  }

  
}