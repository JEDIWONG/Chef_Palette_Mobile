import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.screen});

  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chef Palette',
      debugShowCheckedModeBanner: false,
      home: screen,
    );
  }
}