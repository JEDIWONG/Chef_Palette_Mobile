import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/steps_bar.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget{
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Welcome,",style: CustomStyle.lightLargeHeading),
            Text("Delicacy Ahead",style: CustomStyle.lightLargeHeading,),
            Container(
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.fromLTRB(40,50,40,100),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30))
              ),
              child: Column(
                children: [
                  const StepsBar(index: 0, len: 2), 
                  SizedBox(height: 50,),
                  TextFormField(             
                    decoration: const InputDecoration(
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.email_rounded)
                    ),
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(            
                    obscureText: true, 
                    decoration: const InputDecoration(
                      label: Text("Password"),
                      prefixIcon: Icon(Icons.lock)
                    ),
                  ),
                  const SizedBox(height: 30,),
                  TextFormField(            
                    obscureText: true, 
                    decoration: const InputDecoration(
                      label: Text("Reenter Password"),
                      prefixIcon: Icon(Icons.lock)
                    ),
                  ),
                  const SizedBox(height: 50,),
                  RectButton(
                    bg: Colors.deepPurpleAccent,
                    fg: Colors.white,
                    text: "Next", func: (){}, rad: 10
                  )
                ],
              ),
              
            )
          ],
        ),
      )
    );
  }
}