import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  String? _errorMessage;

  // Firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to send password reset email
  Future<void> _sendResetEmail() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter your email.";
      });
      return;
    }

    try {
       // Check if email exists in Firebase
          final email = _emailController.text;
          QuerySnapshot query =  await FirebaseFirestore.instance.collection('users').where("e-mail", isEqualTo: email).get();

          if (query.docs.isEmpty) {
            setState(() {
              _errorMessage = "No account found for this email.";
            });
            return;
          }

            // Generate a random 6-digit OTP
          final otp = Random().nextInt(900000) + 100000;

          // Store OTP and email in Firestore (or locally for demo purposes)
          await FirebaseFirestore.instance.collection('passwordResets').doc(_emailController.text).set({
            'otp': otp,
            'createdAt': Timestamp.now(),
          });

          // Send email with OTP
          await FirebaseAuth.instance.sendPasswordResetEmail(
            email: _emailController.text,
          );

          setState(() {
            _isOtpSent = true;
            _errorMessage = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP sent to your email. Please check.")),
          );
    } 
    
    on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  // Function to verify OTP (For demo purposes, assume OTP is "123456")
  void _verifyOtp() {
    if (_otpController.text == "123456") {
      Navigator.pop(context); // Navigate back to Login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP verified. Check email to reset password.")),
      );
    } else {
      setState(() {
        _errorMessage = "Invalid OTP. Please try again.";
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
            Text(
              _isOtpSent
                  ? "Enter the OTP sent to your email to reset your password."
                  : "Enter your email to receive a reset link or OTP.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (!_isOtpSent)
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            if (_isOtpSent)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: "OTP Code",
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
              onPressed: _isOtpSent ? _verifyOtp : _sendResetEmail,
              child: Text(_isOtpSent ? "Verify OTP" : "Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
