import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget{
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 100,
        leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
        title: Text(
          "Admin Dashboard",
          style: CustomStyle.lightH2,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
          ],
        ),
      ),
    ); 
  }
}