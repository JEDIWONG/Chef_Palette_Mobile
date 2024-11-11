import 'package:flutter/material.dart';

class Logo extends StatelessWidget{
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/logo.png"))
        ),
      ),
    );
  }
}