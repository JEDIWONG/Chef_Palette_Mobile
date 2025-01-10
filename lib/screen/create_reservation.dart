import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/date_picker_popout.dart';
import 'package:chef_palette/component/no_of_person_picker_popout.dart';
import 'package:chef_palette/controller/reservation_controller.dart'; // Import the controller
import 'package:chef_palette/models/reservation_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateReservation extends StatefulWidget {
  const CreateReservation({super.key});

  @override
  _CreateReservationState createState() => _CreateReservationState();
}

class _CreateReservationState extends State<CreateReservation> {
  final ReservationController _reservationController = ReservationController();

  String selectedDate = "Select Date"; // State for date
  String selectedTime = "Select Time"; // State for time
  int numberOfPersons = 1; // State for number of persons
  String notes = ""; // State for notes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leadingWidth: MediaQuery.sizeOf(context).width * 0.30,
        leading: const CustomBackButton(
          title: 'back',
          first: false,
        ),
        title: Text(
          "Create Reservation",
          style: CustomStyle.h3,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                blurRadius: 1,
                blurStyle: BlurStyle.normal,
                spreadRadius: 1,
                color: Colors.grey,
              ),
            ],
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Reservation Information",
                  style: CustomStyle.h3,
                ),
              ),

              // Date Picker
              ListTile(
                leading: const Text("Date To Come"),
                title: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => DatePickerPopout(
                        onDateSelected: (date) {
                          setState(() {
                            selectedDate = "${date.day}-${date.month}-${date.year}";
                          });
                        },
                      ),
                    );
                  },
                  child: Text(selectedDate),
                ),
              ),

              // Time Picker
              ListTile(
                leading: const Text("Time To Come"),
                title: ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime.format(context);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(selectedTime),
                ),
              ),

              // Number of Persons Picker
              ListTile(
                leading: const Text("Number Of Person"),
                title: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("$numberOfPersons"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => NoOfPersonPickerPopout(
                        onPersonSelected: (i) {
                          setState(() {
                            numberOfPersons = i;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              // Notes Field
              ListTile(
                leading: const Text("Notes"),
                title: TextFormField(
                  decoration: const InputDecoration(
                    focusColor: Colors.green,
                    label: Text("Enter Some Notes"),
                  ),
                  onChanged: (value) {
                    setState(() {
                      notes = value; // Update notes as the user types
                    });
                  },
                ),
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                    // Check if required fields are selected
                    if (selectedDate == "Select Date" || selectedTime == "Select Time") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select both date and time."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Parse the selectedDate string into a DateTime object
                    DateTime parsedDate = DateTime(
                      int.parse(selectedDate.split('-')[2]), // Year
                      int.parse(selectedDate.split('-')[1]), // Month
                      int.parse(selectedDate.split('-')[0]), // Day
                    );

                    // Create the reservation model
                    ReservationModel reservation = ReservationModel(
                      date: parsedDate,
                      time: TimeOfDay(
                        hour: int.parse(selectedTime.split(":")[0]),
                        minute: int.parse(selectedTime.split(":")[1]),
                      ),
                      numberOfPersons: numberOfPersons,
                      notes: notes,
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      status: 'Pending',
                    );

                    // Add the reservation to Firestore
                    await _reservationController.addReservation(reservation);

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Reservation created successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Navigate back
                    Navigator.pop(context);
                  },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Confirm"),
                  ),

                  const SizedBox(width: 20),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
