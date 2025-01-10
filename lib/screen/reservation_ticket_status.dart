import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:chef_palette/controller/reservation_controller.dart';
import 'package:chef_palette/models/reservation_model.dart';
import 'package:flutter/services.dart';

class ReservationTicketStatus extends StatefulWidget {
  const ReservationTicketStatus({super.key, required this.reservationId});

  final String reservationId;

  @override
  _ReservationTicketStatusState createState() => _ReservationTicketStatusState();
}

class _ReservationTicketStatusState extends State<ReservationTicketStatus> {
  final ReservationController _reservationController = ReservationController();
  ReservationModel? reservation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReservationDetails();
  }

  Future<void> fetchReservationDetails() async {
    try {
      // Fetch the reservation details by ID
      ReservationModel? fetchedReservation = await _reservationController.getReservationById(widget.reservationId);

      setState(() {
        reservation = fetchedReservation;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load reservation details: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Reservation Details"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : reservation == null
              ? Center(
                  child: Text("Reservation not found."),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Text(
                        reservation!.status,
                        style: CustomStyle.h2,
                      ),
                      SizedBox(height: 30,),
                      ListTile(
                        minLeadingWidth: MediaQuery.sizeOf(context).width*0.5,
                        leading: Text("Date",style: CustomStyle.h5,),
                        title: Text(
                            "${reservation!.date.day}-${reservation!.date.month}-${reservation!.date.year}"),
                      ),
                      ListTile(
                        minLeadingWidth: MediaQuery.sizeOf(context).width*0.5,
                        leading: Text("Time",style: CustomStyle.h5,),
                        title: Text(
                            "${reservation!.time.hour}:${reservation!.time.minute}"),
                      ),
                      ListTile(
                        minLeadingWidth: MediaQuery.sizeOf(context).width*0.5,
                        leading: Text("Person",style: CustomStyle.h5,),
                        title: Text("${reservation!.numberOfPersons}"),
                      ),
                      ListTile(
                        minLeadingWidth: MediaQuery.sizeOf(context).width*0.2,
                        leading: Text("Notes",style: CustomStyle.h5,),
                        title: Text(reservation!.notes),
                      ),
                      ListTile(
                        
                        leading: Text("ID: ",style: CustomStyle.h5,),
                        title: Text(widget.reservationId),
                        trailing: IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            // Copy reservation ID to clipboard
                            Clipboard.setData(ClipboardData(text: widget.reservationId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Reservation ID copied to clipboard."),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
