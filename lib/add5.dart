import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mangoapp/add6.dart';
import 'add4.dart';

class MangoFarmDetailsPage2 extends StatefulWidget {
  final String farmId; // Add farmId as a parameter

  MangoFarmDetailsPage2({required this.farmId, Key? key}) : super(key: key);

  @override
  _MangoFarmDetailsPage2State createState() => _MangoFarmDetailsPage2State();
}

class _MangoFarmDetailsPage2State extends State<MangoFarmDetailsPage2> {
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _treeCountController = TextEditingController();
  final TextEditingController _ageOfTreesController = TextEditingController();
  String _selectedMangoVariety = '';
  bool _showNewVarietyTextField = false; // Added this variable

  Future<void> _saveMangoVarietyDetails(BuildContext context) async {
    // Get the current user
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Save mango variety details to Firestore under FarmerDetails5 subsection
      String subfolder = 'users/${user.uid}/${widget.farmId}/';

      await FirebaseFirestore.instance
          .collection(subfolder)
          .doc('FarmerDetails5')
          .set({
        'mangoVariety': _selectedMangoVariety,
        'area': _areaController.text,
        'treeCount': _treeCountController.text,
        'ageOfTrees': _ageOfTreesController.text,
      });

      // Navigate to the next page (OtherPlantsDetailsPage or any other page)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MangoFarmDetailsPage1(farmId: widget.farmId),
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
                'Please enter mango farm details here',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color(0xff218f00),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildSubHeading('Mango Variety'),
            SizedBox(height: 10),
            _buildDropDown('Name of the mango variety', [
              "ALPHONSO",
              "ATHIMATHURAM",
              "BANGANAPALLI",
              "CHERUKURASAM",
              "CHAUSA",
              "DEUGAD ALPHONSO",
              "DHASERI",
              "HIMAM PASAND",
              "JAHANGIR",
              "JAWARI",
              "KALAPADI",
              "KESAR",
              "KOPPUR BANGANAPALLI",
              "KOPPUR KALAPADI",
              "KOPPUR RUMAN",
              "LANGRA",
              "MALLIKA",
              "MALGOVA",
              "MALIHABADI DHASHERI",
              "NEELAM",
              "PANCHAVARNAM",
              "PATTANI GOVA",
              "PEDDHA RASAL",
              "PETHER",
              "RATHNAGIRI ALPHONSO",
              "RUMANI",
              "SENDHURA",
              "SWARNAREKHA",
              "TOTAPURI/ BANGAWRA",
              "VADU MANGAI",
              "Others", // Added "Others" option
            ]),
            if (_selectedMangoVariety == "Others") ...[
              SizedBox(height: 10),
              _buildTextField(
                'Enter the name of the new mango variety',
                TextInputType.text,
                _ageOfTreesController,
              ),
            ],
            SizedBox(height: 20),
            _buildSubHeading('Area of this variety'),
            SizedBox(height: 10),
            _buildTextField('Area spent on this variety in acres',
                TextInputType.number, _areaController),
            SizedBox(height: 20),
            _buildSubHeading('Count of trees in this variety'),
            SizedBox(height: 10),
            _buildTextField('Number of trees of this variety',
                TextInputType.number, _treeCountController),
            SizedBox(height: 20),
            _buildSubHeading('Age of trees'),
            SizedBox(height: 10),
            _buildTextField('Period since the trees are planted(in yrs/months)',
                TextInputType.text, _ageOfTreesController),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveMangoVarietyDetails(context);
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
          value:
              _selectedMangoVariety.isNotEmpty ? _selectedMangoVariety : null,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _selectedMangoVariety = value ?? '';
            });
          },
        ),
      ),
    );
  }
}
