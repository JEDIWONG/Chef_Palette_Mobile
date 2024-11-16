import 'package:flutter/material.dart';

class RectButton extends StatelessWidget{
  const RectButton({super.key, required this.bg, required this.fg, required this.text, required this.func, required this.rad});

  final Color bg; 
  final Color fg;
  final String text;
  final Function func; 
  final double rad;

  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: (){func();},
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
        backgroundColor: bg,
        foregroundColor: fg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(rad)),
        )
      ),
      child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold
            ),
        )
    );

  }

}

