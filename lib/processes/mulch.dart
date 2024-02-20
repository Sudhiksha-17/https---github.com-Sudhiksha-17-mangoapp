import 'package:flutter/material.dart';

class MulchingPage extends StatelessWidget {
  final TextEditingController laborsController = TextEditingController();
  final TextEditingController materialController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mulching'),
        backgroundColor: Color(0xffffc900),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextFieldWithLabel(
              'Number of Labors',
              'Enter number of labors',
              laborsController,
            ),
            SizedBox(height: 16),
            _buildTextFieldWithLabel(
              'Material for Mulching',
              'Enter material for mulching',
              materialController,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Add functionality for uploading images for mulching
                print('Upload Images for Mulching');
              },
              icon: Icon(Icons.attach_file),
              label: Text('Images for Mulching'),
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
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    ],
  );
}
