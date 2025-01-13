import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

    @override
    _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();

    @override
    void dispose() {
        _emailController.dispose();
        super.dispose();
    }

    Future<void> _changeEmail() async {
  
        if (_formKey.currentState!.validate()) {
          try{
            final userId = FirebaseAuth.instance.currentUser?.uid; // Replace with logic to retrieve the actual user ID
            final newEmail = _emailController.text.trim(); // Trim whitespace for safety
            bool _isUpdating = false;
            bool _isTimeout = false;
        
            setState(() {
                _isUpdating = true;
                _isTimeout = false;
              });
 // Handle email change logic here
             updateUserEmail(userId!, newEmail);
            // Assuming you have a method to update the email in your database
            
            } catch (e) {
      // Handle errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to change email: $e')),
              );
            }
          }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Change Email Address'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        children: [
                            TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(labelText: 'New Email Address'),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                    if (value == null || value.isEmpty) {
                                        return 'Please enter an email address';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                        return 'Please enter a valid email address';
                                    }
                                    return null;
                                },
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: _changeEmail,
                                child: Text('Change Email'),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
    
      Future<void> updateUserEmail(String userId, String newEmail) async {
          try {
    // Get the current authenticated user
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Update email in Firebase Authentication
      await user.verifyBeforeUpdateEmail(newEmail).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification email sent to $newEmail. Please verify to complete the email update.')),
        );
      });
      // Update email in Firestore user document
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      await userRef.update({'email': newEmail});
    } else {
      throw Exception('No authenticated user found');
    }
  } on FirebaseAuthException catch (e) {
    // Log and rethrow the erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Failed to change email."),
        ),
      );
        Navigator.pop(context);
    }

   
      }
}