import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/style/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String? _selectedLocation;
  List<String> _locations = []; 
  final _addressController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser?.uid; // Replace with your logic to get the current user's ID

  //final List<String> _locations = ['Location 1', 'Location 2', 'Location 3'];

  Future<void> fetchLocationsFromDatabase() async {
  try {
    final userDoc = FirebaseFirestore.instance
    .collection('users')
    .doc(userId);

    final snapshot = await userDoc.get();
    
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() ?? {};

     // _locations.clear(); // Clear the local list and add all location fields
      // data.forEach((key, value) {
      //   if (key.startsWith('location')) {
      //     _locations.add(value as String);
      //   }
      // });

       if (data.containsKey('locations')) {
        setState(() {
          _locations = List<String>.from(data['locations']);
        });
       }
      _selectedLocation = data['selected_location'] as String?;
      debugPrint("The detected: ${_locations.toString()}");
      setState(() {}); // Refresh the UI
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to fetch locations: $e")),
    );
  }
}

Future<void> saveSelectedLocationToDatabase(String selectedLocation) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'selected_location': selectedLocation});
    debugPrint("Selected location saved: $selectedLocation");
  } catch (e) {
    debugPrint("Failed to save selected location: $e");
    Fluttertoast.showToast(
            backgroundColor: Colors.red,
            msg: "Error: Your network connection might have problem. PLease try again later.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
  }
}


 Future<void> saveLocationToDatabase(String location) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Replace with your logic to get the current user's ID
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    // Fetch the current user document
    final snapshot = await userDoc.get();
    Map<String, dynamic> existingData = snapshot.data() ?? {};

    // Find the next available location field name
    // int locationIndex = 1;
    // while (existingData.containsKey('location$locationIndex')) {
    //   locationIndex++;
    // }
    // String newField = 'location$locationIndex';

    // Update the database with the new location
   // await userDoc.update({newField: location});
    
     await userDoc.update({
      'locations': FieldValue.arrayUnion([location])
    });

  
    // Update the local list
    setState(() {
      _locations.add(location);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Location saved as $location successfully!")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to save location: $e")),
    );
  }
}

@override
void initState() {
  super.initState();
  fetchLocationsFromDatabase(); // Fetch locations from Firestore on load
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(title: "Account", first: false),
        leadingWidth: MediaQuery.sizeOf(context).width * 0.4,
        title:  Text("Location",style: CustomStyle.h3,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.symmetric(vertical: 50),
              child: _locations.isEmpty
                  ? const Center(
                      child: Text(
                        "No locations added",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  return RadioListTile<String>(

                    title: Text(_locations[index]),
                    value: _locations[index],
                    groupValue: _selectedLocation,
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value;
                      });
                      saveSelectedLocationToDatabase(_selectedLocation!);
                      //saveLocationToDatabase(value!);
                    },
                  );
                },
              ),
            ),
          
            // Bottom button to show address form
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Show the bottom sheet form
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Enter Your Address", style: CustomStyle.h4,),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: "Address",
                                border: OutlineInputBorder(),
                                hintText: "Enter your address",
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                
                              ),
                              
                              onPressed: () {
                                
                                  if (_addressController.text.isNotEmpty) {
                                  setState(() {
                                    saveLocationToDatabase(_addressController.text); // Add the new location
                                    _addressController.clear(); // Clear the input
                                  });
                                  Navigator.pop(context); // Close the bottom sheet
                                } else {
                                  Fluttertoast.showToast(
                                  backgroundColor: Colors.red,
                                  msg: "Location cannot be empty!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                }// Close the bottom sheet
                              },
                              child: const Text("Submit Address"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  fixedSize: Size(MediaQuery.sizeOf(context).width * 0.8, 50),
                ),
                child: const Text(
                  "Add New Address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
