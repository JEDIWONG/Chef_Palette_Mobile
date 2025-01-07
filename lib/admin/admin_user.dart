import 'package:chef_palette/admin/component/member_card.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class AdminUser extends StatelessWidget{
  const AdminUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        
        title: Text(
          "Members",
          style: CustomStyle.h3,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 50,),
          const MemberCard(memberId: "12dawwwwwwwwdwdwada", joinDate: "12-12-2024")
        ],
      ),
    );
  }
  
}