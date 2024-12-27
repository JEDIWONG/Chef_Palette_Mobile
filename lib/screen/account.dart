import 'package:chef_palette/auth/auth.dart';
import 'package:chef_palette/component/account_card.dart';
import 'package:chef_palette/component/account_setting.dart';
import 'package:chef_palette/component/change_name.dart';
import 'package:chef_palette/models/user_model.dart';
import 'package:chef_palette/services/firestore_services.dart';
import 'package:chef_palette/style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String firstName = "";
  String lastName = "";
  String joinDate = "";

   void _editName() {
    showDialog(
      context: context,
      builder: (context) {
        return EditNameDialog(
          currentFirstName: firstName,
          currentLastName: lastName,
          onSave: (newFirstName, newLastName) {
            setState(() {
              firstName = newFirstName;
              lastName = newLastName;
            });
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data (replace with your own logic for Firestore or database fetching)
  Future<void> _fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    // Ensure user is not null
    if (user != null) {
      
      FirestoreService firestoreService = FirestoreService();
      UserModel? currUser = await firestoreService.getUser(user.uid);

      
      setState(() {
        firstName = currUser?.firstName ?? "Default First Name";  // Default if null
        lastName = currUser?.lastName ?? "Default Last Name";      // Default if null
        joinDate = "12-12-2024";
      });

      
    }
    
  }

  // Sign-out function
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Auth()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        child: Column(
          children: [
            // Pass dynamic user data to AccountCard
            AccountCard(
              firstName: firstName,
              lastName: lastName,
              joinDate: joinDate,
              onEditName: _editName,
            ),
            ListTile(
              title: Text("Features", style: CustomStyle.h3),
            ),
            const AccountTile(title: "Transaction History", icon: Icons.receipt),
            const AccountTile(title: "Location", icon: Icons.location_city),
            const AccountTile(title: "Payment Method", icon: Icons.payment_rounded),
            const AccountSetting(),
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: _signOut,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.red),
                foregroundColor: Colors.red,
                fixedSize: Size(MediaQuery.sizeOf(context).width - 80, 50),
              ),
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  const AccountTile({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Add navigation or on-tap functionality here
      },
      splashColor: Colors.green,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: CustomStyle.txt),
        trailing: const Icon(Icons.navigate_next_rounded),
      ),
    );
  }
}
