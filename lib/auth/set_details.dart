import 'package:chef_palette/services/firestore_services.dart';
import 'package:chef_palette/auth/set_branch.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/steps_bar.dart';
import 'package:chef_palette/models/user_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterStep2 extends StatefulWidget {
  const RegisterStep2({super.key, required this.uid, required this.email});

  final String email;
  final String uid;
  
  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  //final _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  final FirestoreService _firestoreService = FirestoreService();
  String joinDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // ISO 8601 format
  bool isFormComplete =  false;
  
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'MY';
  PhoneNumber number = PhoneNumber(isoCode: 'MY');
  
  Future<void> _saveUserData() async {

     setState(() {
          isFormComplete = true; // Mark the form as complete
  });
                
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty || controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    if(!RegExp(r'^(\+|00)?[0-9]+$').hasMatch(number.phoneNumber.toString())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number")),
      );
      return;
    }

    else
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
        phoneNumber: number.phoneNumber.toString(),
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


  Future<bool> _onWillPop() async {
    if (!isFormComplete) {

      // Show the warning popup
      bool? shouldLeave = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Incomplete Form"),
          content: const Text("Are you sure you want to leave? Your progress will be lost."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false), // Stay on the page
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true), // Allow navigation
              child: const Text("Leave"),
            ),
          ],
        ),
      );
    await FirebaseAuth.instance.currentUser?.delete(); //undo account creation
    return shouldLeave ?? false; // Default to staying on the page
    }
      
    return true; // Allow navigation if the form is complete
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
            onWillPop: _onWillPop,
    child: Scaffold(
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
                   
                    // TextFormField(
                    //   controller: _phoneNumberController,
                    //   decoration: const InputDecoration(
                    //     label: Text("Phone Number"),
                    //     prefixIcon: Icon(Icons.phone),
                    //   ),
                    // ),
                   
                      InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        print(number.phoneNumber);
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        useBottomSheetSafeArea: true,
                      ),
                      ignoreBlank: true,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: controller,
                      formatInput: true,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true, decimal: true),
                      inputBorder: const OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
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
    ),
    );
  }
}
