import 'package:flutter/material.dart';

class VarietySelectionPage extends StatefulWidget {
  @override
  _VarietySelectionPageState createState() => _VarietySelectionPageState();
}

class _VarietySelectionPageState extends State<VarietySelectionPage> {
  String selectedOption = '';
  late final TextEditingController _newVarietyController;

  final List<String> varieties = [
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
  ];

  @override
  void initState() {
    super.initState();
    _newVarietyController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Variety Selection'),
        backgroundColor: Color(0xffffc900),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDropDown('Select a variety', varieties),
            if (selectedOption == "Others") ...[
              SizedBox(height: 10),
              _buildTextField(
                'Enter the name of the new mango variety',
                TextInputType.text,
                _newVarietyController,
              ),
            ],
            // Add other widgets as needed
          ],
        ),
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
}
