import 'package:chef_palette/services/firestore_services.dart';
import 'package:chef_palette/auth/set_branch.dart';
import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/steps_bar.dart';
import 'package:chef_palette/models/user_model.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegisterStep2 extends StatefulWidget {
  const RegisterStep2({super.key, required this.password, required this.email});

  final String email;
  final String password;
  
  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  //final _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController controller = TextEditingController();
  String joinDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // ISO 8601 format
  bool isFormComplete =  false;
  
 
  String initialCountry = 'MY';
  PhoneNumber number = PhoneNumber(isoCode: 'MY');

  
  Future<void> _saveUserData() async {

    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty || controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }
//ceck phone num format 

    else
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Select Your Birthday date")),
      );
      return;
    }
    else{
  
        setState(() {
                isFormComplete = true; // Mark the form as complete
        });
 ///
 ///
 ///
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      String? uid = userCredential.user?.uid;

        if(uid != null){
            UserModel user = UserModel(
              uid: uid,
              email: widget.email,
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              phoneNumber: number.phoneNumber.toString(),
              dob: "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}",
              joinDate: joinDate,
            );

            await _firestoreService.createUser(user);

             final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      
        }
        else 
        {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to create user")),
          );
          return;
        }

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
                            setState(() {
                              this.number = number; // Update state
                            });
                            debugPrint('Phone Number Changed: ${number.phoneNumber}');
                          },
                          onInputValidated: (bool value) {
                            debugPrint('Phone Number Valid: $value');
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            useBottomSheetSafeArea: true,
                          ),
                          ignoreBlank: false,
                          validator: (userInput) {
                                if (userInput!.isEmpty) {
                                  return 'Please enter your phone number';
                                }

                                // Ensure it is only digits and optional '+' or '00' for the country code.
                                if (!RegExp(r'^(\+|00)?[\-\0-9]+$').hasMatch(userInput.replaceAll(' ', ''))) {
                                  return 'Please enter a valid phone number';
                                }
                              
                                return null; // Return null when the input is valid
                          },
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          selectorTextStyle: const TextStyle(color: Colors.black),
                          initialValue: number,
                          textFieldController: controller,
                          formatInput: true,
                          keyboardType: TextInputType.phone,
                          inputBorder: const OutlineInputBorder(),
                          hintText: 'Phone Number',
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
