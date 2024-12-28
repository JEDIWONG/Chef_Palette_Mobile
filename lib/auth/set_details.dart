import 'package:chef_palette/services/firestore_services.dart';
import 'package:chef_palette/auth/set_branch.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/steps_bar.dart';
import 'package:chef_palette/models/user_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';


class RegisterStep2 extends StatefulWidget {
  const RegisterStep2({super.key, required this.uid, required this.email});

  final String uid;
  final String email;

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  final FirestoreService _firestoreService = FirestoreService();
  String joinDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // ISO 8601 format

  Future<void> _saveUserData() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Select Your Birthday date")),
      );
      return;
    }
    else{

      UserModel user = UserModel(
        uid: widget.uid,
        email: widget.email,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        dob: "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
        joinDate: joinDate,
      );

      await _firestoreService.createUser(user);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterStep3(),
        ),
      );

    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 100),
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Almost There,", style: CustomStyle.lightLargeHeading),
              Text("Set Your Details", style: CustomStyle.lightLargeHeading),
              Container(
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.only(top: 50),
                padding: const EdgeInsets.fromLTRB(40, 50, 40, 100),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    const StepsBar(index: 1, len: 3), // Step 1 indicator
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        label: Text("First Name"),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        label: Text("Last Name"),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        label: Text("Phone Number"),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ListTile(
                      leading: Text(
                        "Date of Birth",
                        style: CustomStyle.h4,
                      ),
                    ),
                    SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.single,
                      backgroundColor: const Color.fromARGB(255, 231, 255, 234),
                      selectionColor: Colors.green,
                      todayHighlightColor: const Color.fromARGB(255, 255, 191, 0),
                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                        setState(() {
                          _selectedDate = args.value;
                        });
                      },
                    ),
                    const SizedBox(height: 50),
                    RectButton(
                      bg: const Color.fromARGB(255, 51, 64, 129),
                      fg: const Color.fromARGB(255, 255, 255, 255),
                      text: "Move On",
                      func: _saveUserData,
                      rad: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
