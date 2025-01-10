import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/screen/create_reservation.dart';
import 'package:chef_palette/screen/reservation_ticket.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Reservation extends StatelessWidget{
  const Reservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
        leading: const CustomBackButton(
          title: 'Menu',
          first: false,
        ),
        title: Text(
          "Reservation",
          style: CustomStyle.h1,
        ),
      ), 
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text(
              "Starts An Reservation", 
              style: CustomStyle.h3,
            ),
            
            Container(
              margin: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
              child: Column(
                spacing: 10,
                children: [
                    ReservationTile(
                      title: "Make a new reservation",
                      subtitle: "Fill in Reservation Information",
                      dest: CreateReservation()
                    ),

                    ReservationTile(
                      title: "Reservation Ticket",
                      subtitle: "Check Reservation Details",
                      dest: ReservationTicket()
                    ),
                ],
              ),
            )
            
          ], 
        ),
      ),
    );
  }
  
}

class ReservationTile extends StatelessWidget{
  const ReservationTile({super.key, required this.title, required this.subtitle, required this.dest});

  final String title; 
  final String subtitle;
  final Widget dest;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        side: BorderSide(
          width: 1,
          color: Colors.green
        )
      ),
      iconColor: Colors.green,
      leading: Icon(Icons.task),
      title: Text(title,style: CustomStyle.h4),
      subtitle: Text(subtitle,style: CustomStyle.subtitle,),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>dest)); 
      },
    ); 
  }
}
  