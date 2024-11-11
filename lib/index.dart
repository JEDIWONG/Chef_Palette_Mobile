
import 'package:chef_palette/component/logo.dart';
import 'package:chef_palette/screen/menu.dart';
import 'package:chef_palette/screen/order.dart';
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
    const Menu(),
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
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Logo(),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_rounded))
        ],
        centerTitle: true,
        elevation: 1.0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.grey,
        backgroundColor: Colors.white,
      ),

      body: pageList.elementAt(selectedIndex),

      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: const Color.fromARGB(255, 59, 248, 66),
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
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
      ),
      
    );
  }
  
}