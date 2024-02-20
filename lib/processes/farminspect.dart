import 'package:flutter/material.dart';

class FarmInspectPage extends StatelessWidget {
  final TextEditingController countController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Inspection Log'),
        backgroundColor: Color(0xffffc900).withOpacity(0.7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextFieldWithLabel('Visit Number', 'Enter', countController),
            SizedBox(height: 16),
            _buildTextFieldWithLabel(
                'Purpose of visit', 'Give us the reason', purposeController),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Add functionality for uploading soil report
                print('Images of visit');
              },
              icon: Icon(Icons.attach_file),
              label: Text('Images'),
            ),
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
