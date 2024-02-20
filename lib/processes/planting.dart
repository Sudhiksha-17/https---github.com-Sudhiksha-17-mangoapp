import 'package:flutter/material.dart';

class PlantingPage extends StatelessWidget {
  final TextEditingController bedPreparationController =
      TextEditingController();
  final TextEditingController irrigationTypeController =
      TextEditingController();
  final TextEditingController densityLevelController = TextEditingController();
  final TextEditingController rowColumnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planting'),
        backgroundColor: Color(0xffffc900),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextFieldWithLabel(
              'Type of bed preparation',
              'Enter type of bed preparation',
              bedPreparationController,
            ),
            SizedBox(height: 16),
            _buildTextFieldWithLabel(
              'Irrigation type',
              'Enter irrigation type',
              irrigationTypeController,
            ),
            SizedBox(height: 16),
            Text(
              'Distance between the plants',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Density level',
                    ['Option 1', 'Option 2'],
                    densityLevelController,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    'Row/column',
                    ['Row', 'Column'],
                    rowColumnController,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(
    String label,
    String hintText,
    TextEditingController controller,
  ) {
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

  Widget _buildDropdown(
    String hint,
    List<String> options,
    TextEditingController controller,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint),
          value: controller.text.isNotEmpty ? controller.text : null,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            // Handle dropdown value changes
            controller.text = value ?? '';
          },
        ),
      ),
    );
  }
}
