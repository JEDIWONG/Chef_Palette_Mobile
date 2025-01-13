import 'package:chef_palette/screen/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget{
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
     String userid = FirebaseAuth.instance.currentUser!.uid;
     
      return Container(
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.symmetric(vertical: 50),
      
        child: Column(
          children: [
            ListTile(
              leading: const Text("Good Day",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
              trailing: IconButton(
                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen(userId: userid)));}, 
                style: IconButton.styleFrom(
                  backgroundColor: Colors.amber,
                  elevation: 3.0
                ),
                icon:  const Icon(Icons.notifications_rounded,color: Colors.black,),
              )
            ),
             ListTile(
              title: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: 45,
                child:  const SearchBar(
                leading: Icon(Icons.search),
                hintText: "Search",
              ),
              )
            ),
            
          ],
        ),
      );
  }
}