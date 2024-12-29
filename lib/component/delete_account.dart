import 'package:chef_palette/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmDeleteAccount extends StatelessWidget {
  const ConfirmDeleteAccount({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      // Delete the user's account

      String oldUserid = FirebaseAuth.instance.currentUser!.uid;
      
      await FirebaseAuth.instance.currentUser?.delete();
      
      await FirebaseFirestore.instance.collection('users').doc(oldUserid).delete();
    
      // Delete the user's document from Firestore
      // Navigate to the home or login page after account deletion
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Auth()), // Replace with your login page
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // Show an error if account deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Failed to delete account."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm Delete Account"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Are you sure you want to delete your account?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back if user selects "No"
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("No"),
                  ),
                  ElevatedButton(
                    onPressed: () => _deleteAccount(context), // Delete account if user selects "Yes"
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Yes"), 
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
