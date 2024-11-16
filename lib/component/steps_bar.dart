import 'package:flutter/material.dart';

class StepsBar extends StatelessWidget {
  const StepsBar({super.key, required this.index, required this.len});

  final int index;
  final int len;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(len, (i) {
        return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          width: 50,
          height: 10,
          decoration: BoxDecoration(
            color: i == index ? Colors.deepPurpleAccent:Colors.green , // Dynamic color based on index
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.all(20),
        
        );
      }),
    );
  }
}