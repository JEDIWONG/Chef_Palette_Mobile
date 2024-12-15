import 'package:chef_palette/screen/account.dart';
import 'package:chef_palette/screen/cart.dart';
import 'package:chef_palette/screen/menu.dart';
import 'package:chef_palette/screen/order.dart';
import 'package:chef_palette/screen/rewards.dart';
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
    const Rewards(),
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
        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Cart()));},
        backgroundColor: Colors.amberAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.shopping_cart)
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _switchPage, 
        selectedItemColor: const Color.fromARGB(255, 59, 248, 66),
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        iconSize: 30,
        type: BottomNavigationBarType.fixed,
      
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
            icon: Icon(Icons.money_rounded),
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