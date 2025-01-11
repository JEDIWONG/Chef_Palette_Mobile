//ununsed since now we use firebase own page to reset password

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  _SetNewPasswordState createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _setNewPassword() async {

    if(_passwordController.text.isEmpty && _currentPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in both entries.";
      });
      return;
    }

    if (_currentPasswordController.text.isEmpty && _passwordController.text.isNotEmpty) {
      setState(() {
        _errorMessage = "Please enter your current password.";
      });
      return; 
    }

    if (_passwordController.text.isEmpty && _currentPasswordController.text.isNotEmpty){
      setState(() {
        _errorMessage = "Please enter a new password.";
      });
      return;
    } 

    if(_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = "Password must be at least 6 characters.";
      });
      return;
    }

    if(_passwordController.text.isNotEmpty && _passwordController.text == _currentPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords must be different.";
      });
      return;
    }

    try {

    final user = FirebaseAuth.instance.currentUser;

    if (user!= null) {
              final cred = EmailAuthProvider.credential(
                email: user.email ?? "",
                password: _currentPasswordController.text,
              );
                
              await user.reauthenticateWithCredential(cred); 

              await user.updatePassword(_passwordController.text); 
               
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password reset successfully.")),
            );

    }
            Navigator.pop(context);
          } catch (e) {
            setState(() {
              _errorMessage = "Failed to reset password.";
            });
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set New Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Enter New Password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setNewPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text("Reset Password"),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
