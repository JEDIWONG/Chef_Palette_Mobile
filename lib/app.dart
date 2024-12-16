import 'package:chef_palette/auth/auth.dart';
import 'package:chef_palette/auth/login.dart';
import 'package:chef_palette/auth/register.dart';
import 'package:chef_palette/auth/set_details.dart';
import 'package:chef_palette/index.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chef Palette',
      debugShowCheckedModeBanner: false,
      home: Auth(),
    );
  }
}