import 'package:chef_palette/component/custom_button.dart';
import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String? _selectedLocation;

  final List<String> _locations = ['Location 1', 'Location 2', 'Location 3'];
  final _addressController = TextEditingController();

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
              child: ListView.builder(
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
                                
                                Navigator.pop(context); // Close the bottom sheet
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
                  "Enter Address",
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
