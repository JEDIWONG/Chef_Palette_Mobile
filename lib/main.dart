import 'package:chef_palette/auth/auth.dart';
import 'package:chef_palette/index.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if user session exists
  final isUserLoggedIn = await checkSession();

  runApp(MyApp(screen: isUserLoggedIn ? const Index() : const Auth()));

  
}

Future<bool> checkSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}
