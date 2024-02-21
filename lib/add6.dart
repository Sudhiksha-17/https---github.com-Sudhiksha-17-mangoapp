import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add9.dart';

class OtherPlantsDetailsPage extends StatefulWidget {
  final String farmId;

  OtherPlantsDetailsPage({required this.farmId, Key? key}) : super(key: key);

  @override
  _OtherPlantsDetailsPageState createState() => _OtherPlantsDetailsPageState();
}

class _OtherPlantsDetailsPageState extends State<OtherPlantsDetailsPage> {
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _areaUtilizedController = TextEditingController();
  final TextEditingController _countOfPlantsController =
      TextEditingController();
  String _selectedIrrigationMethod = '';

  int _cropVarietyCounter = 1; // Counter for crop variety subsections

  Future<void> _saveCropDetails(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String subfolder = 'users/${user.uid}/${widget.farmId}/';

      // Save crop details to Firestore under CropVarieties collection
      await FirebaseFirestore.instance
          .collection(subfolder)
          .doc('OtherPlantDetails1')
          .collection('CropVarieties')
          .doc('cropVariety$_cropVarietyCounter')
          .set({
        'cropName': _cropNameController.text,
        'areaUtilized': _areaUtilizedController.text,
        'countOfPlants': _countOfPlantsController.text,
        'irrigationMethod': _selectedIrrigationMethod,
      });

      // Increment the crop variety counter for the next entry
      _cropVarietyCounter++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Others',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold), // Text color
        ),
        backgroundColor: Color(0xffffc900),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: Color(0xffffffff),
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Please enter details about other plants here',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildSubHeading('Crop Name'),
                SizedBox(height: 10),
                _buildTextField('Name of the crop', TextInputType.text,
                    _cropNameController),
                SizedBox(height: 20),
                _buildSubHeading('Area Utilized'),
                SizedBox(height: 10),
                _buildTextField('Area spent on this crop in acres',
                    TextInputType.number, _areaUtilizedController),
                SizedBox(height: 20),
                _buildSubHeading('Count of Plants'),
                SizedBox(height: 10),
                _buildTextField('Number of plants of this crop',
                    TextInputType.number, _countOfPlantsController),
                SizedBox(height: 20),
                _buildSubHeading('Irrigation Method'),
                SizedBox(height: 10),
                _buildDropDown(
                  'Method of irrigation',
                  [
                    'Drip irrigation',
                    'Sprinkler irrigation',
                    'Surface irrigation'
                  ],
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigation logic to the next page for adding crops
                    _saveCropDetails(context);
                    setState(() {
                      // Reset input fields after saving
                      _cropNameController.text = '';
                      _areaUtilizedController.text = '';
                      _countOfPlantsController.text = '';
                      _selectedIrrigationMethod = '';
                    });
                  },
                  child: Text(
                    '+ Add crop',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement submit button functionality
                      _saveCropDetails(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UploadScreen(farmId: widget.farmId)));
                    },
                    child:
                        Text('Continue', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006227),
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

  Widget _buildSubHeading(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(String placeholder, TextInputType inputType,
      TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder,
        border: OutlineInputBorder(),
      ),
      keyboardType: inputType,
    );
  }

  Widget _buildDropDown(String placeholder, List<String> options) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(placeholder),
          value: _selectedIrrigationMethod.isNotEmpty
              ? _selectedIrrigationMethod
              : null,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _selectedIrrigationMethod = value ?? '';
            });
          },
        ),
      ),
    );
  }
}
