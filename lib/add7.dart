import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add6.dart';

class OtherPlantsDetailsPage2 extends StatefulWidget {
  final String farmId; // Add farmId as a parameter

  OtherPlantsDetailsPage2({required this.farmId, Key? key}) : super(key: key);

  @override
  _OtherPlantsDetailsPage2State createState() =>
      _OtherPlantsDetailsPage2State();
}

class _OtherPlantsDetailsPage2State extends State<OtherPlantsDetailsPage2> {
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _plantCountController = TextEditingController();
  String _selectedIrrigationMethod = '';

  Future<void> _saveOtherPlantsDetails(BuildContext context) async {
    // Get the current user
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Save other plants details to Firestore under FarmerDetails7 subsection
      String subfolder = 'users/${user.uid}/${widget.farmId}/';

      await FirebaseFirestore.instance
          .collection(subfolder)
          .doc('OtherPlantDetails2')
          .set({
        'cropName': _cropNameController.text,
        'area': _areaController.text,
        'plantCount': _plantCountController.text,
        'irrigationMethod': _selectedIrrigationMethod,
      });

      // Navigate to the next page (OtherPlantsDetailsPage or any other page)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtherPlantsDetailsPage(farmId: widget.farmId),
        ),
      );
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
        children:[
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
            _buildSubHeading('Crop Name'),
            SizedBox(height: 10),
            _buildTextField(
                'Name of the crop', TextInputType.text, _cropNameController),
            SizedBox(height: 20),
            _buildSubHeading('Area Utilized'),
            SizedBox(height: 10),
            _buildTextField('Area spent on this crop in acres',
                TextInputType.number, _areaController),
            SizedBox(height: 20),
            _buildSubHeading('Count of Plants'),
            SizedBox(height: 10),
            _buildTextField('Number of plants of this crop',
                TextInputType.number, _plantCountController),
            SizedBox(height: 20),
            _buildSubHeading('Irrigation Method'),
            SizedBox(height: 10),
            _buildDropDown(
              'Method of irrigation',
              ['Drip irrigation', 'Sprinkler irrigation', 'Surface irrigation'],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveOtherPlantsDetails(context);
                },
                child: Text('Save', style: TextStyle(color: Colors.white)),
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
