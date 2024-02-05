import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; 
import 'add9.dart';

class OtherPlantsDetailsPage extends StatefulWidget {
  final String farmId;

  OtherPlantsDetailsPage({required this.farmId, Key? key}) : super(key: key);

  @override
  _OtherPlantsDetailsPageState createState() =>
      _OtherPlantsDetailsPageState();
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
        backgroundColor: Color(0xffffc900),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xff054500),
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
                      fontStyle: FontStyle.italic,
                      color: Color(0xff218f00),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              
                _buildTextFieldWithLabel(
                  'Name of the crop',
                  'Enter crop name',
                  _cropNameController,
                  isRequired: true,
                ),
                SizedBox(height: 20),
               
                _buildTextFieldWithLabel(
                  'Area spent on this crop in acres',
                  'Enter area in acres',
                  _areaUtilizedController,
                  isNumeric: true,
                  isRequired: true,
                ),
                SizedBox(height: 20),
               
                _buildTextFieldWithLabel(
                  'Number of plants of this crop',
                  'Enter number of plants',
                  _countOfPlantsController,
                  isNumeric: true,
                  isRequired: true,
                ),
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

  Widget _buildSubHeading(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xff218f00),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(
    String label, String hintText, TextEditingController controller,
    {bool isNumeric = false, bool isRequired = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff218f00),
        ),
      ),
      SizedBox(height: 10),
      TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
          errorText: isRequired && controller.text.isEmpty ? 'Please enter the details' : null,
        ),
        onChanged: (value) {
          if (isRequired) {
            setState(() {}); // Trigger a rebuild to update the error text dynamically
          }
        },
      ),
    ],
  );
  }

  Widget _buildDropDown(String placeholder, List<String> options) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
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
