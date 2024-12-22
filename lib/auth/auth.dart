import "package:chef_palette/auth/login.dart";
import "package:chef_palette/auth/register.dart";
import "package:chef_palette/component/custom_button.dart";
import "package:chef_palette/style/style.dart";
import "package:flutter/material.dart";

class Auth extends StatelessWidget{

  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
        Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
           ),
        ),
      ),
      
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Image.asset("assets/images/logo.png",width: 200,),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 70),
            child: Column(
              children: [
                RectButton(
                  bg: CustomStyle.primary,
                  fg: Colors.white,
                  text: "Login",
                  rad: 10,
                  func: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Login()));}
                ),

                const SizedBox(height: 50,),

                RectButton(
                  bg: Colors.white,
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
      ],
    ),
  );
  }
}