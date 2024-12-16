import 'package:chef_palette/index.dart';
import 'package:chef_palette/style/style.dart';
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
        shadowColor: Colors.black,
        elevation: 3,
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

class CustomBackButton extends StatelessWidget{
  const CustomBackButton({super.key, required this.title, required this.first});

  final String title; 
  final bool first; 

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        
        if(first==false){
          Navigator.pop(context);
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Index()));
        }
        
      }, 
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(100))
        )
      ),
      child: Row(
        spacing: 10,
        children: [
          const Icon(Icons.arrow_back,color: Colors.white,),
          
          Text(title,style: CustomStyle.h5,),
        ],
      )
    );
  }

}
