import 'package:chef_palette/screen/account.dart';
import 'package:chef_palette/screen/cart.dart';
import 'package:chef_palette/screen/menu.dart';
import 'package:chef_palette/screen/order.dart';
import 'package:chef_palette/screen/rewards.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Index extends StatefulWidget{
  const Index({super.key});

  @override
  State<Index> createState()=> IndexState();

}

class IndexState extends State<Index>{

  DateTime? currentBackPressTime;
  final String exit_warning = "Press back again to exit boi";
  bool canPopNow = false;
  int requiredSeconds = 2;
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

  void onPopInvoked(bool didPop) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || 
        now.difference(currentBackPressTime ?? now) > Duration(seconds: requiredSeconds)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: exit_warning);
      Future.delayed(
        Duration(seconds: requiredSeconds),
        () {
          // Disable pop invoke and close the toast after 2s timeout
          setState(() {
            canPopNow = false;
          });
          Fluttertoast.cancel();
        },
      );
      // Ok, let user exit app on the next back press
      setState(() {
        canPopNow = true;
      });
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,

      body: PopScope(
       canPop: canPopNow,
       // ignore: deprecated_member_use
       onPopInvoked: onPopInvoked,
       child:pageList.elementAt(selectedIndex),
      ),
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
    


  



