import "package:chef_palette/auth/login.dart";
import "package:chef_palette/auth/register.dart";
import "package:chef_palette/component/custom_button.dart";
import "package:flutter/material.dart";

class Auth extends StatelessWidget{

  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white70,
      body: Column(
        children: [

          Container(
            margin: const EdgeInsets.only(top: 100),
            child: Center(
              child: Image.asset("assets/images/logo.png",width: 200,),
            )
          ),
          const Text("Chef Palette",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 50),
            child: Column(
              children: [
                RectButton(
                  bg: Colors.deepPurple,
                  fg: Colors.white70,
                  text: "Login",
                  rad: 10,
                  func: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login()));}
                ),

                const SizedBox(height: 50,),

                RectButton(
                  bg: Colors.white70,
                  fg: Colors.deepPurple,
                  text: "Sign Up",
                  rad: 10,
                  func: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Register()));}
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}