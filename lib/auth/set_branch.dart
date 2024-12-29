import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/component/steps_bar.dart';
import 'package:chef_palette/index.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


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

  String? selectedBranch;
  // List of branch coordinates (latitude, longitude)
  final List<Map<String, dynamic>> branches = [
    {'name': 'Kota Samarahan', 'latitude': 1.4643256, 'longitude': 110.415054},
    {'name': 'Kuching Jalan Padungan', 'latitude': 1.5566214, 'longitude': 110.351420},
    {'name': 'Sabah Segama Complex', 'latitude': 5.9424039, 'longitude': 116.0568832},
    {'name': 'Wilayah Persekutuan Labuan', 'latitude': 5.2790732, 'longitude': 115.2429376},
    {'name': 'Selangor', 'latitude': 3.0738379, 'longitude': 101.5183467},
    {'name': 'Perak', 'latitude': 4.5921, 'longitude': 101.0901},
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


  String? selectedState;
  String? nearestBranch;
  bool _isLoading = false;

  Future<void> _detectNearestBranch() async {

    setState(() {
      _isLoading = true;
    });

    //LocationService locationService = LocationService();
    Position? position = await _RegisterStep3State().getCurrentLocation(context);

    if (position != null) {
      String branch = _RegisterStep3State().getNearestBranch(position);
      setState(() {
        nearestBranch = branch;
        selectedState = branch;
      });

    setState(() {
      _isLoading = false;
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
  // final List<String> states = [
  //   "Sabah",
  //   "Kota Samarahan Sarawak",
  //   "Kuching Jalan Padungan Sarawak",
  //   "Kuala Lumpur",
  //   "Selangor",
  //   "Perak",
  // ];

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
                    items: branches.map((branch) {
                      return DropdownMenuItem<String>(
                        value: branch['name'],
                        child: Text(branch['name']),
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
                    text: _isLoading ? "Loading..." : "Get Nearest Branch",
                    func: _isLoading ? (){} : _detectNearestBranch,
                    
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
                  RectButton(
                    bg: Colors.purple,
                    fg: const Color.fromARGB(255, 255, 255, 255),
                    text: "Finish Setup",
                    func: (){
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Index(initIndex: 0,)),
                          (route) => false,
                      );
                    },
                    
                    rad: 10,
                  ),

                  const SizedBox(height: 20),
                  InkWell(
                    splashColor: Colors.green,
                    onTap: (){
                       Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Index(initIndex: 0,)), // home page after login
                          (route) => false, // This removes all routes (i.e., Auth, Login, etc.) from the stack
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

