import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mangoapp/add8.dart';
import 'package:mangoapp/displayfarms.dart';

class UploadScreen extends StatelessWidget {
  final String farmId;

  UploadScreen({required this.farmId, Key? key}) : super(key: key);

  Future<void> _uploadPhotos(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await _uploadFile(imageFile, 'photos', context);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadVideos(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);
      await _uploadFile(videoFile, 'videos', context);
    } else {
      print('No video selected.');
    }
  }

  Future<void> _uploadFile(File file, String folder, BuildContext context) async {
    await Firebase.initializeApp();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final photoRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/$farmId/$folder');

      final ref = photoRef.child(
          '${DateTime.now().millisecondsSinceEpoch}${file.path.split('/').last}');

      await ref.putFile(file);

      final downloadURL = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('uploadedFiles')
          .add({
        'fileType': folder,
        'downloadURL': downloadURL,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('File uploaded to: $downloadURL');

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Upload Complete"),
            content: Text("The file has been successfully uploaded."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
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
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Upload Media',
          style: TextStyle(color: Color(0xff054500)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _uploadPhotos(context);
              },
              child:
                  Text('Upload Photos', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff02c44f),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await _uploadVideos(context);
              },
              child:
                  Text('Upload Videos', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff02c44f),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FarmAddedSuccessPage()));
              },
              child: Text('Submit', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF006227),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
