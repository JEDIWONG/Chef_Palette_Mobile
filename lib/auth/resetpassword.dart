import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
    
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;
  // Firebase auth instance

  // Function to send password reset email
  Future<void> _sendResetEmail() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter your email.";
      });
      return;
    }

    setState(() { 
     _errorMessage = null; 
  });

    try {
       // Check if email exists in Firebase
          String email = _emailController.text;
          QuerySnapshot query =  await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: email).get();
          
          if (query.docs.isEmpty) {
            setState(() {
              _errorMessage = "No account found for this email.";
            });
            return;
          }

          // Send email with OTP
          await FirebaseAuth.instance.sendPasswordResetEmail(
            email: _emailController.text,
          );

          setState(() {
            _errorMessage = null;

          });

          
        Navigator.pop(context); // Navigate back to Login
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Reset link sent to your email. Please check.")),
          
          );
    } 
    
    on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Forgot Password?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text( "Enter your email to receive a link to reset password."
                  ,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
           
            const SizedBox(height: 10),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:  _sendResetEmail,
              child: const Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
