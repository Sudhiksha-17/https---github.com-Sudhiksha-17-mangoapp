import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'add3.dart';

class AddFarmsPage2 extends StatefulWidget {
  final String farmId;

  AddFarmsPage2({required this.farmId, Key? key}) : super(key: key);

  @override
  _AddFarmsPage2State createState() => _AddFarmsPage2State();
}

class _AddFarmsPage2State extends State<AddFarmsPage2> {
  late final TextEditingController _farmLandController =
      TextEditingController();
  late final TextEditingController _mangoAreaController =
      TextEditingController();
  late final TextEditingController _otherCropsAreaController =
      TextEditingController();

  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _retrieveLocation() async {
    Location location = Location();
    try {
      LocationData currentLocation = await location.getLocation();
      setState(() {
        _locationData = currentLocation;
         _showLocationUpdatedDialog();
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _showLocationUpdatedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Updated"),
          content: Text("Your location has been updated."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }



  // Convert LocationData to JSON format
  Map<String, dynamic> _locationDataToJson(LocationData locationData) {
    return {
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
      'accuracy': locationData.accuracy,
      // Add other properties as needed
    };
  }

  Future<void> _saveFarmDetails(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Use the provided farmId parameter to create the subfolder
      String subfolder = 'users/${user.uid}/${widget.farmId}/';

      await FirebaseFirestore.instance
          .collection(subfolder)
          .doc('FarmerDetails2') // Store details under FarmerDetails2 document
          .set({
        'farmLandArea': _farmLandController.text,
        'mangoArea': _mangoAreaController.text,
        'otherCropsArea': _otherCropsAreaController.text,
        'location': _locationData != null
            ? _locationDataToJson(_locationData!)
            : null, // Save location data
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MangoFarmDetailsPage(farmId: widget.farmId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Farms',
          style: TextStyle(color: Color(0xff054500)), // Text color
        ),
        backgroundColor: Color(0xffffc900),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xff054500),
          onPressed: () {
            // Navigate back to the display farms page
            Navigator.pop(context);
          },
        ), // Background color
      ),
      body: ListView(
        children:[
          Container(
          color: Color(0xffffffff), // Background color #D3FFA6
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please enter farm details here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color(0xff218f00),
                ),
              ),
              SizedBox(height: 20.0),
              _buildHyperlinkedText('Farm location', 'Choose location on maps'),
              _buildFormField(
                  'Farm Land', 'Enter area in acres', _farmLandController),
              _buildFormField('Area (Mangoes)',
                  'Area spent on mango trees in acres', _mangoAreaController),
              _buildFormField('Area (Other crops)',
                  'Area spent on others in acres', _otherCropsAreaController),
              SizedBox(height: 20.0),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveFarmDetails(context);
                  },
                  child: Text('Continue', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF006227),
                  ),
                ),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildHyperlinkedText(String heading, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20.0),
        Text(
          heading,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff218f00),
          ),
        ),
        SizedBox(height: 5.0),
        GestureDetector(
          onTap: () {
            _retrieveLocation(); // Retrieve location when clicked
          },
          child: Row(
            children: [
              Icon(Icons.location_pin),
              SizedBox(width: 5.0),
              Text(
                text,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(
      String heading, String placeholder, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20.0),
        Text(
          heading,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff218f00),
          ),
        ),
        SizedBox(height: 5.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
