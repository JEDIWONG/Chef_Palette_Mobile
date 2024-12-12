import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import '../component/search.dart';

class Menu extends StatelessWidget{
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Search(),
        centerTitle: true,
        elevation: 3.0,
        shadowColor: Colors.black,
        backgroundColor: CustomStyle.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40))
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //CategoryBar(),
          ],
        ),
      ),
    );
  }
  
}