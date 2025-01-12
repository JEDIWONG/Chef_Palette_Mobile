import 'package:chef_palette/admin/admin_menu.dart';
import 'package:chef_palette/admin/admin_order.dart';
import 'package:chef_palette/admin/admin_reservation.dart';
import 'package:chef_palette/admin/admin_rewards.dart';
import 'package:chef_palette/admin/admin_transaction.dart';
import 'package:chef_palette/admin/admin_user.dart';
import 'package:chef_palette/admin/component/dashboard_card.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    List <String> name = ["Manage Order","Manage Menu","Manage Reservation","Transaction Record","Manage Rewards","Manage Members"];
    List <Widget> widget = [const AdminOrder(),const AdminMenu(),ReservationAdminPanel(),const AdminTransaction(),const AdminRewards(),const AdminUser()]; 
    DateTime? lastPressed;
    

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressed == null || now.difference(lastPressed!) > const Duration(seconds: 2)) {
          // Show toast if back button is pressed once
          lastPressed = now;
          Fluttertoast.showToast(
            backgroundColor: Colors.green,
            msg: "Press back again to go to the login page",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          return false; // Prevent navigation
        }
        // Navigate to the login page on the second press
        return true;
      },
    // return Scaffold(
    child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.green,
        toolbarHeight: 100,
        leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
        title: Text(
          "Admin Dashboard",
          style: CustomStyle.lightH2,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 10, 
            mainAxisSpacing: 20, 
            childAspectRatio: 1/1.1
          ),
          itemCount: 6, 
          itemBuilder: (context, index) {
            return DashboardCard(
              target: widget[index],
              title: name[index],
              iconUrl: "assets/images/settings.png",
            );
          },
        ),
      ),
    ),
    );
  }
}
