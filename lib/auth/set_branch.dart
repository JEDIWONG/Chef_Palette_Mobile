import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/steps_bar.dart';
import 'package:chef_palette/index.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class LocationService {
  // List of branch coordinates (latitude, longitude)
  final List<Map<String, dynamic>> branches = [
    {'name': 'Kuching, Kota Samarahan', 'latitude': 1.4643256, 'longitude': 110.415054},
    {'name': 'Kuching Kota Padungan', 'latitude': 1.5566214, 'longitude': 110.351420},
    {'name': 'Sabah Segama Complex', 'latitude': 5.9424039, 'longitude': 116.0568832},

  ];

  // Function to calculate the nearest branch
  String getNearestBranch(Position userPosition) {
    double minDistance = double.infinity;
    String nearestBranch = '';

    for (var branch in branches) {
      double distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        branch['latitude'],
        branch['longitude'],
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestBranch = branch['name'];
      }
    }

    return nearestBranch;
  }


//get current location
 Future<Position?> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showDialog(context, "Error", "Please enable location services.");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showDialog(context, "Permission Denied", "Location permission is required.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showDialog(context, "Permission Denied Forever", "Enable location permission from settings.");
      return null;
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}

  // Function to show dialog box
  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


class RegisterStep3 extends StatefulWidget {
  const RegisterStep3({super.key});

  @override
  _RegisterStep3State createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  String? selectedState;
  String? nearestBranch;

  Future<void> _detectNearestBranch() async {
    LocationService locationService = LocationService();
    Position? position = await locationService.getCurrentLocation(context);

    if (position != null) {
      String branch = locationService.getNearestBranch(position);
      setState(() {
        nearestBranch = branch;
        selectedState = branch;
      });

      // Show detected branch dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Detected Nearest Branch"),
          content: Text("Your nearest branch is: $branch"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  // List of states in Malaysia
  final List<String> states = [
    "Sabah",
    "Kota Samarahan Sarawak",
    "Kuching Padungan Sarawak",
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
                    func: _detectNearestBranch,
                    
                    //() {
                      // if (selectedState != null) {
                      //   // Handle the submission with the selected state
                      //   print("Selected State: $selectedState");
                      // } else {
                      //   // Handle the case where no state is selected
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text("Please select a state."),
                      //     ),
                      //   );
                      // }
                   // },
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

