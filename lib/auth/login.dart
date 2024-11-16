import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/index.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget{
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment:MainAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text("Sign In Account",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white),),
          ), 
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 500,
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, -1),
                  blurRadius: 1,
                  blurStyle: BlurStyle.normal,
                )
              ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(             
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    prefixIcon: Icon(Icons.email_rounded)
                  ),
                ),
                const SizedBox(height: 40,),
                TextFormField(            
                  obscureText: true, 
                  decoration: const InputDecoration(
                    label: Text("Password"),
                    prefixIcon: Icon(Icons.lock)
                  ),
                ),
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: (){},
                    child: const Text("Forgot Password ?",style: TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.bold),),
                  ),
                ),
                const SizedBox(height: 60,),
                RectButton(
                  bg: Colors.green,
                  fg: Colors.white,
                  text: "Sign In",
                  func: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Index()));},
                  rad: 10
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  
}