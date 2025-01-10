import 'package:chef_palette/screen/reservation_ticket_status.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class ReservationTicketCard extends StatelessWidget{
  const ReservationTicketCard({super.key, required this.status, required this.date, required this.time, required this.reservationId});

  final String status;
  final String date;
  final String time;
  final String reservationId;

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context)=>ReservationTicketStatus(reservationId: reservationId)
          )
        );
      },

      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.green, 
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey, 
              blurRadius: 1,
              blurStyle: BlurStyle.normal,
              spreadRadius: 1,
              offset: Offset(1, 1)
            )
          ]
        ),
        child: ListTile(
          title: Text(status,style: CustomStyle.lightH2,),
          trailing: Icon(Icons.navigate_next,color: Colors.white,),
          subtitle: Column(
            children: [
              Text(date,style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold,fontSize: 18,fontStyle: FontStyle.italic),),
              Text(time,style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold,fontSize: 14,fontStyle: FontStyle.italic),),
            ],
          ),
        )
      ),
    );
  }  

  
}