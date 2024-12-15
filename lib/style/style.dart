import 'package:flutter/material.dart';

class CustomStyle{

  static TextStyle lightLargeHeading = const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 255, 255, 255));

  static TextStyle h1 = const TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: Colors.black,fontFamily:String.fromEnvironment("segoe ui"));
  static TextStyle h2 = const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black);
  static TextStyle h3= const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black);
  static TextStyle h4 = const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black);
  static TextStyle h5 = const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black);
  static TextStyle txt = const TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.black);
  
  static TextStyle link = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.blue,
    decoration: TextDecoration.underline,
    decorationColor: Colors.blue
  );

  static TextStyle link2 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  static TextStyle subtitle = const TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.grey);

  static Color primary = const Color.fromARGB(255, 37, 117, 30);
  static Color secondary = const Color.fromARGB(255, 147, 209, 160);

}