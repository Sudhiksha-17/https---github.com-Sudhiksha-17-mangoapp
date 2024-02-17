import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mangoapp/add2.dart';
import 'package:mangoapp/displayfarms.dart';
import 'package:uuid/uuid.dart';
import 'add2.dart';

class AddFarmsPage extends StatefulWidget {
  final String farmId;

  AddFarmsPage({required this.farmId, Key? key}) : super(key: key);

  @override
  _AddFarmsPageState createState() => _AddFarmsPageState();
}

class _AddFarmsPageState extends State<AddFarmsPage> {
  late final TextEditingController _farmerNameController =
      TextEditingController();
  late final TextEditingController _phoneNumberController =
      TextEditingController();
  late final TextEditingController _addressLine1Controller =
      TextEditingController();
  late final TextEditingController _addressLine2Controller =
      TextEditingController();
  late final TextEditingController _addressLine3Controller =
      TextEditingController();
  List<FilePickerResult?>? _selectedFiles;

  Future<void> _saveFarmerDetails(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String subfolder = 'users/${user.uid}/${widget.farmId}/';

      DocumentReference<Map<String, dynamic>> documentReference =
          FirebaseFirestore.instance.collection(subfolder).doc('FarmDetails1');

      documentReference.set({
        'farmerName': _farmerNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'addressLine1': _addressLine1Controller.text,
        'addressLine2': _addressLine2Controller.text,
        'addressLine3': _addressLine3Controller.text,
      });

      if (_selectedFiles != null && _selectedFiles!.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _buildProgressDialog();
          },
          barrierDismissible: false,
        );

        try {
          List<String> fileUrls = await _uploadFilesToStorage(
            _selectedFiles!,
            user.uid,
            widget.farmId,
            (double progress) {
              // Update progress bar here if needed
              print("Upload Progress: ${(progress * 100).toStringAsFixed(2)}%");
            },
          );

          Navigator.of(context).pop(); // Close the progress dialog
          Navigator.of(context).popUntil((route) => route.isFirst);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _buildConfirmationDialog();
            },
          );

          await documentReference.update({'fileUrls': fileUrls});
        } catch (error) {
          print("Error uploading files: $error");
          // Handle error (display a message, log it, etc.)
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddFarmsPage2(farmId: widget.farmId),
        ),
      );
    }
  }

  Future<List<String>> _uploadFilesToStorage(
    List<FilePickerResult?> selectedFiles,
    String userId,
    String farmId,
    Function(double) onProgress,
  ) async {
    List<String> fileUrls = [];
    String subfolder = 'users/$userId/$farmId/';

    for (var fileResult in selectedFiles) {
      if (fileResult != null && fileResult.files.isNotEmpty) {
        final file = fileResult.files.first;
        final fileName =
            file.name ?? 'file${DateTime.now().millisecondsSinceEpoch}';
        final ref = FirebaseStorage.instance.ref().child(
            '$subfolder${DateTime.now().millisecondsSinceEpoch}_$fileName');

        String farmerIdSubfolder = '$subfolder/Farmer_Id/';
        final StorageRef = FirebaseStorage.instance.ref().child(
            '$farmerIdSubfolder${DateTime.now().millisecondsSinceEpoch}_$fileName');

        final uploadTask = StorageRef.putData(file.bytes!);
        uploadTask.snapshotEvents.listen(
          (TaskSnapshot snapshot) {
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;
            onProgress(progress);
          },
        );

        await uploadTask; // Wait for the upload to complete

        final downloadURL = await StorageRef.getDownloadURL();
        fileUrls.add(downloadURL);
      }
    }

    return fileUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Farms',
          style: TextStyle(color: Color(0xff054500)),
        ),
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
                Text(
                  'Please enter farm details here',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff218f00),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 10),
                _buildTextFieldWithLabel(
                    'Farmer Name', 'Enter Farmer Name', _farmerNameController),
                SizedBox(height: 10),
                _buildTextFieldWithLabel('Phone Number', 'Enter Phone Number',
                    _phoneNumberController),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Farm Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff218f00),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _addressLine1Controller,
                      decoration: InputDecoration(
                        hintText: 'Address Line 1',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _addressLine2Controller,
                      decoration: InputDecoration(
                        hintText: 'Address Line 2(optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.attach_file),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'jpg', 'png'],
                        );
                        if (result != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _buildProgressDialog();
                            },
                            barrierDismissible: false,
                          );

                          setState(() {
                            _selectedFiles = [result];
                          });

                          // Upload the selected files immediately
                          await _uploadFilesToStorage(
                            _selectedFiles!,
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.farmId,
                            (double progress) {
                              // Update progress bar here if needed
                              print(
                                  "Upload Progress: ${(progress * 100).toStringAsFixed(2)}%");
                            },
                          );
                        }
                      },
                      child: Text(
                        'Farmer ID Proof',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _saveFarmerDetails(context);
                    },
                    child:
                        Text('Continue', style: TextStyle(color: Colors.white)),
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

  Widget _buildProgressDialog() {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Uploading..."),
        ],
      ),
    );
  }

  Widget _buildConfirmationDialog() {
    return AlertDialog(
      title: Text("Upload Complete"),
      content: Text("The image has been uploaded successfully."),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddFarmsPage(farmId: "your_farm_id"), // Provide a farmId here
  ));
}
