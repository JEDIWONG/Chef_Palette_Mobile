//TODO:

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SetNewPassword extends StatefulWidget {
  final String email;
  const SetNewPassword({required this.email, Key? key}) : super(key: key);

  @override
  _SetNewPasswordState createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _setNewPassword() async {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a new password.";
      });
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset successfully.")),
      );
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
