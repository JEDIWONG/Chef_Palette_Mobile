import 'package:chef_palette/component/search.dart';
import 'package:chef_palette/screen/account.dart';
import 'package:chef_palette/screen/menu.dart';
import 'package:chef_palette/screen/order.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget{
  const Index({super.key});

  @override
  State<Index> createState()=> IndexState();
  
}

class IndexState extends State<Index>{

  int selectedIndex =0;

  static List<Widget> pageList = [
    const Menu(),
    const Order(),
    const Menu(),
    const Account(),
  ];

  void _switchPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: pageList.elementAt(selectedIndex),

      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: const Color.fromARGB(255, 59, 248, 66),
        shape: const CircleBorder(
        ),
        child: const Icon(Icons.shopping_cart)
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _switchPage, 
        selectedItemColor: const Color.fromARGB(255, 59, 248, 66),
        unselectedItemColor: Colors.black,
      
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dinner_dining_rounded),
            label: 'Menu',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Order',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline_rounded),
            label: 'Rewards',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
      ),
      
    );
  }
  
}