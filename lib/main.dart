import 'package:chef_palette/auth/auth.dart';
import 'package:chef_palette/index.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chef Palette',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(), // Splash screen as the first screen
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

    // Navigate to the appropriate screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isUserLoggedIn ? const Index() : const Auth(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_screen.png'), // Replace with your splash image
            fit: BoxFit.cover, // Fills the screen
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(), // Optional loading spinner
        ),
      ),
    );
  }
}

Future<bool> checkSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}  
