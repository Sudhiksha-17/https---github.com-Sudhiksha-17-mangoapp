import 'package:flutter/material.dart';

class IrrigationPage extends StatelessWidget {
  final TextEditingController irritypeController = TextEditingController();
  final TextEditingController countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Irrigation Info'),
        backgroundColor: Color(0xffffc900).withOpacity(0.7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextFieldWithLabel('Irrigation Type',
                'Enter type of irrigation', irritypeController),
            SizedBox(height: 16),
            _buildTextFieldWithLabel(
                'Total number of irrigation', 'Numbers', countController),
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
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
