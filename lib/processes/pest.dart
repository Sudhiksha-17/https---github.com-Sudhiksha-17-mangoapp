import 'package:flutter/material.dart';

class PestPage extends StatelessWidget {
  final TextEditingController pestiController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController laboursController = TextEditingController();
  final TextEditingController modesController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pest & Disease Management'),
        backgroundColor: Color(0xffffc900).withOpacity(0.7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextFieldWithLabel(
                'Pesticides', 'Enter the name', pestiController),
            SizedBox(height: 16),
            _buildTextFieldWithLabel(
                'Brand of Pesticide', 'Enter brand info', brandController),
            SizedBox(height: 16),
            _buildTextFieldWithLabel('Quantity of application',
                'Enter the quantity', quantityController),
            SizedBox(height: 16),
            _buildTextFieldWithLabel('Mode of pesticide feeding',
                'Enter the method of feeding', modesController),
            SizedBox(height: 16),
            _buildTextFieldWithLabel(
                'Number of labourers working', 'Numbers', laboursController),
            SizedBox(height: 16),
            _buildTextFieldWithLabel(
                'Why this pesticide', 'Give us the reason', reasonController),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Add functionality for uploading soil report
                print('Upload images of pesticides');
              },
              icon: Icon(Icons.attach_file),
              label: Text('Upload pictures'),
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
