import 'package:flutter/material.dart';
import 'package:mangoapp/displayfarms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PdfMapsPage extends StatefulWidget {
  final String farmId;

  const PdfMapsPage({Key? key, required this.farmId}) : super(key: key);

  @override
  _PdfMapsPageState createState() => _PdfMapsPageState();
}

class _PdfMapsPageState extends State<PdfMapsPage> {
  late List<String> fileUrls;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _fetchFileUrls();
    _fetchLocationDetails();
  }

  Future<void> _fetchFileUrls() async {
    try {
      // Get the user ID from the currently logged-in user
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Construct the Firebase Storage path for files
        String storagePath =
            'users/$userId/${widget.farmId}/FarmerDetails2/location';

        // Reference to the Firebase Storage folder for files
        Reference storageRef =
            FirebaseStorage.instance.ref().child(storagePath);

        // List all items (files) in the folder
        ListResult result = await storageRef.list();

        // Get the download URLs for each item (file)
        List<String> urls = await Future.wait(
          result.items.map((item) => item.getDownloadURL()).toList(),
        );

        setState(() {
          fileUrls = urls;
        });
      } else {
        // User ID not available
        print('User ID not available.');
        setState(() {
          fileUrls = [];
        });
      }
    } catch (e) {
      print('Error fetching file URLs: $e');
      setState(() {
        fileUrls = [];
      });
    }
  }

  Future<void> _fetchLocationDetails() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection(widget.farmId)
            .doc('FarmerDetails2')
            .get();

        if (documentSnapshot.exists) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          if (data != null && data['location'] != null) {
            // Access latitude and longitude from the location map
            Map<String, dynamic> locationData = data['location'];
            double? latitude = locationData['latitude'] as double?;
            double? longitude = locationData['longitude'] as double?;

            if (latitude != null && longitude != null) {
              setState(() {
                this.latitude = latitude;
                this.longitude = longitude;
              });
            }
          }
        } else {
          print('Document does not exist');
        }
      } else {
        print('User ID not available');
      }
    } catch (e) {
      print('Error fetching location details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDFs and Maps'),
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
                'PDF Display and Map Location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Display the PDFs and photos
            PdfPhotoList(farmId: widget.farmId, fileUrls: fileUrls),
            SizedBox(height: 20),
            // Display the map launcher icon
            MapLauncher(latitude: latitude, longitude: longitude),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FarmsPage(),
                  ),
                );
              },
              child: Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfPhotoList extends StatelessWidget {
  final String farmId;
  final List<String>? fileUrls;

  const PdfPhotoList({Key? key, required this.farmId, this.fileUrls})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (fileUrls == null)
          CircularProgressIndicator()
        else if (fileUrls!.isEmpty)
          Text('No files found.')
        else
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: List.generate(fileUrls!.length, (index) {
              return GestureDetector(
                onTap: () => _launchFile(fileUrls![index]),
                child: Image.network(
                  fileUrls![index],
                  fit: BoxFit.cover,
                ),
              );
            }),
          ),
      ],
    );
  }

  Future<void> _launchFile(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class MapLauncher extends StatelessWidget {
  final double? latitude;
  final double? longitude;

  const MapLauncher({Key? key, this.latitude, this.longitude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _launchMap(latitude, longitude),
      icon: Icon(Icons.map),
      label: Text('Show Map'),
    );
  }

  Future<void> _launchMap(double? latitude, double? longitude) async {
    if (latitude != null && longitude != null) {
      final url =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      print('Latitude and longitude are not available.');
    }
  }
}
