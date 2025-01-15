import 'package:chef_palette/style/style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapPicker extends StatefulWidget {
  final Function(LatLng, String) onLocationPicked;
  final LatLng initialLocation;

  const MapPicker({
    Key? key,
    required this.onLocationPicked,
    required this.initialLocation,
  }) : super(key: key);

  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  LatLng? _selectedLocation;
  String _selectedAddress = "Move the pin to select a location";

  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    _updateAddress(widget.initialLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation,
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onTap: (LatLng location) async {
              setState(() {
                _selectedLocation = location;
              });
              _updateAddress(location);
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected-location'),
                      position: _selectedLocation!,
                      infoWindow: InfoWindow(
                        title: "Selected Location",
                        snippet: _selectedAddress,
                      ),
                    ),
                  }
                : {},
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      _selectedAddress,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectedLocation != null
                      ? () {
                          widget.onLocationPicked(_selectedLocation!, _selectedAddress);
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text("Confirm Location",style: CustomStyle.lightH5,),
                ),
              ],
            ),
          ),
        ],
      );
  }

  Future<void> _updateAddress(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _selectedAddress =
              "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      } else {
        setState(() {
          _selectedAddress = "Address not found";
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = "Error fetching address";
      });
    }
  }
}
