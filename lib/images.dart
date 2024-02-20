import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'videos.dart';

class ImagesPage extends StatefulWidget {
  final String farmId;

  const ImagesPage({Key? key, required this.farmId}) : super(key: key);

  @override
  _ImagesPageState createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  List<String> imageUrls = []; // List to store image URLs

  @override
  void initState() {
    super.initState();
    fetchImageUrls(); // Fetch image URLs when the widget initializes
  }

  Future<void> fetchImageUrls() async {
    try {
      // Construct the Firebase Storage path
      String storagePath =
          'users/${FirebaseAuth.instance.currentUser?.uid}/${widget.farmId}/photos/';

      print('Farm ID: ${widget.farmId}'); // Print the farmId

      // Reference to the Firebase Storage folder
      Reference storageRef = FirebaseStorage.instance.ref().child(storagePath);

      // List all items (images) in the folder
      ListResult result = await storageRef.listAll();

      // Get the download URLs for each item (image)
      List<Future<String>> downloadUrls =
          result.items.map((item) => item.getDownloadURL()).toList();

      // Resolve all the Futures to get the actual download URLs
      List<String> urls = await Future.wait(downloadUrls);

      setState(() {
        imageUrls = urls; // Update the list of image URLs
      });
    } catch (e) {
      print('Error fetching image URLs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
        backgroundColor: Color(0xffffc900),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xff054500),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Images Display Area',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of boxes per row
                childAspectRatio: 1, // Aspect ratio of the boxes (square)
                crossAxisSpacing: 10, // Spacing between the boxes
                mainAxisSpacing: 10, // Spacing between rows
              ),
              itemCount: imageUrls.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    // Handle tap event here, show full-size image
                    // For example, you can show a dialog or navigate to a new page
                    // For simplicity, I'll just print the URL of the tapped image
                    print('Tapped image URL: ${imageUrls[index]}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(imageUrls[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideosPage(farmId: widget.farmId),
                  ),
                );
              },
              child: Text('Next to Videos'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImagesPage(farmId: 'exampleFarmId'),
  ));
}
