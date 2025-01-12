import 'package:chef_palette/auth/auth.dart';
import 'package:chef_palette/index.dart' as cf;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chef Palette',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    // Simulate a splash screen delay
    await Future.delayed(const Duration(seconds: 3));

    // Check if the user is logged in
    final isUserLoggedIn = await checkSession();


//check email to delete authentication data created despite not complete registration
//due to exiting app on the 2nd registration page
//an incomplete file is generated and will removed after registration

    // Navigate to the appropriate screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isUserLoggedIn ? const cf.Index(initIndex: 0,) : const Auth(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_screen.png'), 
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(), 
        ),
      ),
    );
  }
}

Future<bool> checkSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}  
