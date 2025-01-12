import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/reservation_ticket_card.dart';
import 'package:chef_palette/controller/reservation_controller.dart';
import 'package:chef_palette/style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReservationTicket extends StatefulWidget {
  const ReservationTicket({super.key});

  @override
  _ReservationTicketState createState() => _ReservationTicketState();
}

class _ReservationTicketState extends State<ReservationTicket> {
  final ReservationController _reservationController = ReservationController();
  List<Map<String, dynamic>> reservations = []; // To include both reservation data and ID
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserReservations();
  }

  Future<void> fetchUserReservations() async {
    try {
      // Get the current user's ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("No user is currently logged in.");
      }

      // Fetch reservations for the current user
      List<Map<String, dynamic>> fetchedReservations =
          await _reservationController.getReservationsByUserId(userId);

      setState(() {
        reservations = fetchedReservations;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load reservations: $e"),
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
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
        leading: const CustomBackButton(
          title: 'Menu',
          first: false,
        ),
        title: Text(
          "Reservation Ticket",
          style: CustomStyle.h3,
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : reservations.isEmpty
              ? Center(
                  child: Text(
                    "No reservations found.",
                    style: CustomStyle.h4,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: reservations
                        .map(
                          (item) => ReservationTicketCard(
                            status: item['reservation'].status,
                            date:
                                "${item['reservation'].date.day}-${item['reservation'].date.month}-${item['reservation'].date.year}",
                            time:
                                "${item['reservation'].time.hour}:${item['reservation'].time.minute}",
                            reservationId: item['id'], 
                          ),
                        )
                        .toList(),
                  ),
                ),
    );
  }
}
