import 'package:chef_palette/component/search.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget{
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(

      toolbarHeight: 150,
      title: const Search(),
      centerTitle: true,
      elevation: 3.0,
      shadowColor: Colors.black,
      backgroundColor: CustomStyle.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))
      ),
    );
  }
  
}