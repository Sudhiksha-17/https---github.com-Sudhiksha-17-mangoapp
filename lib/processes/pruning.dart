import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PruningPage extends StatefulWidget {
  @override
  _PruningPageState createState() => _PruningPageState();
}

class _PruningPageState extends State<PruningPage> {
  final TextEditingController _laboursController = TextEditingController();
  final TextEditingController _pruningTypeController = TextEditingController();
  final TextEditingController _toolsController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  List<XFile> _selectedImages = [];

  Future<void> _pickImages() async {
    ImagePicker picker = ImagePicker();
    List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pruning Details'),
        backgroundColor: Color(0xffffc900),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextFieldWithLabel(
                'No of Labours', 'Enter number of labours', _laboursController),
            _buildTextFieldWithLabel(
                'Pruning Type', 'Enter pruning type', _pruningTypeController),
            _buildTextFieldWithLabel('Tools for Pruning',
                'Enter tools used for pruning', _toolsController),
            _buildTextFieldWithLabel(
                'Cost of Pruning', 'Enter cost of pruning', _costController),
            SizedBox(height: 16),
            InkWell(
              onTap: _pickImages,
              child: Row(
                children: [
                  Icon(Icons.attach_file),
                  SizedBox(width: 8),
                  Text('Upload Images', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            SizedBox(height: 16),
            _displaySelectedImages(),
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
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _displaySelectedImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Images:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff218f00),
          ),
        ),
        /*SizedBox(height: 10),
        if (_selectedImages.isNotEmpty)
          Column(
            children: _selectedImages.map((image) {
              return Image.file(File(image.path)); 
            }).toList(),
          ),*/
      ],
    );
  }
}
