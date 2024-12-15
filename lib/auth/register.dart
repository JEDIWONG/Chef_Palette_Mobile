import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/steps_bar.dart';
import 'package:chef_palette/index.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

// First Screen
class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Welcome,", style: CustomStyle.lightLargeHeading),
            Text("Delicacy Ahead", style: CustomStyle.lightLargeHeading),
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
                  const StepsBar(index: 0, len: 3), // Step 0 indicator
                  const SizedBox(height: 50),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Email"),
                      prefixIcon: Icon(Icons.email_rounded),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text("Password"),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text("Reenter Password"),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 50),
                  RectButton(
                    bg: Colors.deepPurpleAccent,
                    fg: const Color.fromARGB(255, 255, 255, 255),
                    text: "Next",
                    func: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterStep2(),
                        ),
                      );
                    },
                    rad: 10,
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

class RegisterStep2 extends StatelessWidget {
  const RegisterStep2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
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
                    decoration: const InputDecoration(
                      label: Text("First Name"),
                      prefixIcon: Icon(Icons.settings),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Last Name"),
                      prefixIcon: Icon(Icons.settings),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Phone Number"),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  RectButton(
                    bg: const Color.fromARGB(255, 51, 64, 129),
                    fg: const Color.fromARGB(255, 255, 255, 255),
                    text: "Next",
                    func: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterStep3(),
                        ),
                      );
                    },
                    rad: 10,
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

class RegisterStep3 extends StatefulWidget {
  const RegisterStep3({super.key});

  @override
  _RegisterStep3State createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  String? selectedState;

  // List of states in Malaysia
  final List<String> states = [
    "Sabah",
    "Sarawak",
    "Kuala Lumpur",
    "Selangor",
    "Perak",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Let's Get Things", style: CustomStyle.lightLargeHeading),
            Text("Started", style: CustomStyle.lightLargeHeading),
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
                  const StepsBar(index: 2, len: 3), // Step 3 indicator
                  const SizedBox(height: 50),

                  // Dropdown Button for Malaysian States
                  DropdownButtonFormField<String>(
                    value: selectedState,
                    hint: const Text("Select your state"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: states.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedState = newValue;
                      });
                    },
                  ),

                  const SizedBox(height: 50),
                  RectButton(
                    bg: Colors.green,
                    fg: const Color.fromARGB(255, 255, 255, 255),
                    text: "Get Nearest Branch",
                    func: () {
                      if (selectedState != null) {
                        // Handle the submission with the selected state
                        print("Selected State: $selectedState");
                      } else {
                        // Handle the case where no state is selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select a state."),
                          ),
                        );
                      }
                    },
                    rad: 10,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    splashColor: Colors.green,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Index(),
                        ),
                      );
                      
                    } ,
                    child: Text("Skip For Now",style: CustomStyle.link2,),
                  )
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
