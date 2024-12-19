// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class LocationPage extends StatefulWidget {
//   const LocationPage({super.key});

//   @override
//   _LocationPageState createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   String _locationMessage = "";
//   bool _loading = false;

//   // Function to get the current location and address
//   Future<void> _getLocation() async {
//     setState(() {
//       _loading = true;
//       _locationMessage = "Fetching location...";
//     });

//     // Check for location permission
//     // LocationPermission permission = await Geolocator.requestPermission();
//     // if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//     //   setState(() {
//     //     _loading = false;
//     //     _locationMessage = "Location permission denied.";
//     //   });
//     //   return;
//     // }

//     // Get the current position (latitude and longitude)
//     Position position = await Geolocator.getCurrentPosition();
//     log("this is 37 from latitude ${position.latitude}");
//     log("this is 37 from latitude ${position.longitude}");

//     // Get the address from the coordinates
// try {
//   List<Placemark> placemarks = await placemarkFromCoordinates(
//       position.latitude, position.longitude);

//   if (placemarks.isEmpty) {
//     setState(() {
//       _loading = false;
//       _locationMessage = "No placemarks found for the location.";
//     });
//     return;
//   }

//   Placemark place = placemarks[0];

//   String city = place.locality ?? "Unknown City";
//   String state = place.administrativeArea ?? "Unknown State";
//   String country = place.country ?? "Unknown Country";

//   setState(() {
//     _loading = false;
//     _locationMessage =
//         "Latitude: ${position.latitude}\nLongitude: ${position.longitude}\nCity: $city, State: $state, Country: $country";
//   });
// } catch (e) {
//   setState(() {
//     _loading = false;
//     _locationMessage = "Error retrieving location: $e";
//   });
// }

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_loading)
//               CircularProgressIndicator(), // Show loading indicator while fetching
//             SizedBox(height: 20),
//             Text(
//               _locationMessage,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _getLocation,
//               child: Text('Get My Location'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class LocationService {
  final String apiKey = 'c54c2d55e0104beb98df3ad382e35850';

  // Method to get address from coordinates
  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    final url =
        'https://api.opencagedata.com/geocode/v1/json?key=$apiKey&q=$latitude+$longitude&pretty=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]['formatted'];
      } else {
        return 'No address found.';
      }
    } else {
      throw Exception('Failed to load address');
    }
  }

  // Method to get coordinates from address
  Future<Map<String, double>> getCoordinatesFromAddress(String address) async {
    final url =
        'https://api.opencagedata.com/geocode/v1/json?key=$apiKey&q=$address&pretty=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        double lat = data['results'][0]['geometry']['lat'];
        double lng = data['results'][0]['geometry']['lng'];
        return {'latitude': lat, 'longitude': lng};
      } else {
        throw Exception('No coordinates found for this address');
      }
    } else {
      throw Exception('Failed to load coordinates');
    }
  }
}

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _locationMessage = "";
  final LocationService locationService = LocationService();

  Future<void> _getLocation() async {
    setState(() {
      _locationMessage = "Fetching location...";
    });

    try {
      // Replace with your latitude and longitude
      Position position = await Geolocator.getCurrentPosition();
      // log(position as num);
      // Get address from coordinates
      String address = await locationService.getAddressFromCoordinates(
          position.latitude, position.longitude);

      setState(() {
        _locationMessage = "Address: $address";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Error fetching location: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //   Container(
            //   height: 300.h,
            //   width: 250.w,
            //   child: Column(
            //     children: [
            //       Lottie.asset('assets/voice.json', fit: BoxFit.fill),
            //       Lottie.asset('assets/electrician.json', fit: BoxFit.fill),
            //     ],
            //   ),
            // ),
            Lottie.asset('assets/lazy.json', fit: BoxFit.fill),
            Text(
              _locationMessage,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text('Show your location'),
            ),
          ],
        ),
      ),
    );
  }
}
