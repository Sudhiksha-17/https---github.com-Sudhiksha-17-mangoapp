import 'package:flutter/material.dart';

class LandPreparationPage extends StatelessWidget {
  final TextEditingController soilTypeController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController irrigationTypeController =
      TextEditingController();
  final TextEditingController waterPHController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Land Preparation'),
        backgroundColor: Color(0xffffc900),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextFieldWithLabel(
              'Soil type',
              'Enter soil type',
              soilTypeController,
            ),
            SizedBox(height: 16),
            _buildTextFieldWithLabel(
              'Area',
              'Enter area',
              areaController,
            ),
            SizedBox(height: 16),
            _buildTextFieldWithLabel(
              'Irrigation type',
              'Enter irrigation type',
              irrigationTypeController,
            ),
            SizedBox(height: 16),
            _buildTextFieldWithLabel(
              'Well/Bore water pH',
              'Enter Well/Bore water pH',
              waterPHController,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Add functionality for uploading soil report
                print('Upload Soil Report');
              },
              icon: Icon(Icons.attach_file),
              label: Text('Upload Soil Report'),
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                // Add functionality for recording GPS location
                print('Record GPS Location');
              },
              child: Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 8),
                  Text('GPS Location'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(
      String label, String hintText, TextEditingController controller) {
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
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
