import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mangoapp/add4.dart';
import 'package:mangoapp/add5.dart';

class MangoFarmDetailsPage extends StatefulWidget {
  final String farmId; // Add farmId as a parameter

  MangoFarmDetailsPage({required this.farmId, Key? key}) : super(key: key);

  @override
  _MangoFarmDetailsPageState createState() => _MangoFarmDetailsPageState();
}

class _MangoFarmDetailsPageState extends State<MangoFarmDetailsPage> {
  final TextEditingController _numberOfVarietyController =
      TextEditingController();
  final TextEditingController _numberOfTreesController =
      TextEditingController();
  String selectedOption = '';
  final TextEditingController _yieldController = TextEditingController();

  Future<void> _saveMangoFarmDetails(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String subfolder = 'users/${user.uid}/${widget.farmId}/';

      await FirebaseFirestore.instance
          .collection(subfolder)
          .doc('FarmerDetails3')
          .set({
        'userId': user.uid,
        'numberOfVarieties': _numberOfVarietyController.text,
        'numberOfTrees': _numberOfTreesController.text,
        'irrigationMethod': selectedOption,
        'yieldInPreviousYear': _yieldController.text,
      });

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
            _buildSubHeading('Mango Varieties'),
            SizedBox(height: 10),
            _buildTextField('Number of mango variety', TextInputType.number,
                _numberOfVarietyController),
            SizedBox(height: 20),
            _buildSubHeading('Count of Mango Trees'),
            SizedBox(height: 10),
            _buildTextField('Number of mango tree', TextInputType.number,
                _numberOfTreesController),
            SizedBox(height: 20),
            _buildSubHeading('Irrigation Method'),
            SizedBox(height: 10),
            _buildDropDown(
              'Method of irrigation',
              ['Drip irrigation', 'Sprinkler irrigation', 'Surface irrigation'],
            ),
            SizedBox(height: 20),
            _buildSubHeading('Yield in Previous Year'),
            SizedBox(height: 10),
            _buildTextField('Yield of mangoes in the previous year',
                TextInputType.number, _yieldController),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _saveMangoFarmDetails(context);
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
          value: selectedOption.isNotEmpty ? selectedOption : null,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              selectedOption = value ?? '';
            });
          },
        ),
      ),
    );
  }
}
