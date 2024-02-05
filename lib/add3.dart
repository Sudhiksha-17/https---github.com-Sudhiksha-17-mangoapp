import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter
import 'package:mangoapp/add4.dart';

class MangoFarmDetailsPage extends StatefulWidget {
  final String farmId; // Add farmId as a parameter

  MangoFarmDetailsPage({required this.farmId, Key? key}) : super(key: key);

  @override
  _MangoFarmDetailsPageState createState() => _MangoFarmDetailsPageState();
}

class _MangoFarmDetailsPageState extends State<MangoFarmDetailsPage> {
  late final TextEditingController _numberOfVarietyController =
      TextEditingController();
  late final TextEditingController _numberOfTreesController =
      TextEditingController();
  String selectedOption = '';
  late final TextEditingController _yieldController = TextEditingController();

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
        children: [
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
                
                _buildTextFieldWithLabel('Number of mango variety',
                    'Enter number of mango variety', _numberOfVarietyController,
                    isNumeric: true, isRequired: true),
                SizedBox(height: 20),
                
                _buildTextFieldWithLabel('Number of mango tree',
                    'Enter number of mango tree', _numberOfTreesController,
                    isNumeric: true, isRequired: true),
                SizedBox(height: 20),
                _buildSubHeading('Irrigation Method'),
                SizedBox(height: 10),
                _buildDropDown(
                  'Method of irrigation',
                  ['Drip irrigation', 'Sprinkler irrigation', 'Surface irrigation'],
                ),
                SizedBox(height: 20),
                
                _buildTextFieldWithLabel(
                    'Yield of mangoes in the previous year',
                    'Enter yield in the previous year',
                    _yieldController,
                    isNumeric: true,
                    isRequired: true),
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
  Widget _buildTextFieldWithLabel(
      String label, String hintText, TextEditingController controller, {bool isNumeric = false, bool isRequired = true}) {
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
          inputFormatters: isNumeric
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
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
}
