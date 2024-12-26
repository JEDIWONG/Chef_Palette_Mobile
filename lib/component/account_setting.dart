import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'delete_account.dart';
import 'change_password.dart';

class AccountSetting extends StatelessWidget{
  const AccountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          ListTile(
            leading: Text("Advanced",style: CustomStyle.h3,),
          ),
          ListTile(

            leading: const Icon(Icons.password_rounded),
            title: Text("Change Password",style: CustomStyle.h4,),
            trailing: ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SetNewPassword(), //i dunno if this works or not
                  ),
                );
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                fixedSize: Size(100, 30)
              ),
              child: const Text("Change"),

            ),
          ),
          ListTile(

            leading: const Icon(Icons.delete_forever,color: Colors.red,),
            title: Text("Delete Account",style: CustomStyle.h4,),
          
            trailing: ElevatedButton(
              onPressed: (){
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfirmDeleteAccount(),
                      ),
                );
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                fixedSize: const Size(100, 30)
              ),
              child: const Text("Delete"),

            ),
          )
        ],
      ),
    );
  }

  
}