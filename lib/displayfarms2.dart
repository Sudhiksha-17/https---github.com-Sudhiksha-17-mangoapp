import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'images.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DisplayPage(farmId: 'farmId'),
    );
  }
}

class DisplayPage extends StatefulWidget {
  final String farmId;

  const DisplayPage({Key? key, required this.farmId}) : super(key: key);

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  late String _farmName = '';
  late String _phoneNumber = '';
  //late String _farmAddress = '';
  late String _addressLine1 = '';
  late String _addressLine2 = '';
  //late String _addressline3 ='';
  late String _farmLand = '';
  late String _mangoArea = '';
  late String _otherCropsArea = '';
  late String _locationData = '';
  late String _numberOfVariety = '';
  late String _numberOfTrees = '';
  late String _yield = '';
  late String _selectedIrrigationMethod = '';

  List<QueryDocumentSnapshot<Map<String, dynamic>>> mangoVarieties = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> cropVarieties = [];

  @override
  void initState() {
    super.initState();
    _fetchFarmData();
  }

  Future<void> _fetchFarmData() async {
    try {
      var user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // User not authenticated, handle accordingly
        return;
      }

      String subfolder = 'users/${user.uid}/${widget.farmId}/';

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection(subfolder)
              .doc('FarmDetails1')
              .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        setState(() {
          _farmName = data?['farmerName'] ?? '';
          _phoneNumber = data?['phoneNumber'] ?? '';
          _addressLine1 = data?['addressLine1'] ?? '';
          _addressLine2 = data?['addressLine2'] ?? '';
        });
      } else {
        print('Farm data not found for farmId: ${widget.farmId}');
      }

      documentSnapshot = await FirebaseFirestore.instance
          .collection(subfolder)
          .doc('FarmerDetails2')
          .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        setState(() {
          _farmLand = data?['farmLandArea'] ?? '';
          _mangoArea = data?['mangoArea'] ?? '';
          _otherCropsArea = data?['otherCropsArea'] ?? '';
          //_locationData = data?['location'] != null
          //  ? _locationDataToJson(data?['location'])
          //: '';
        });
      } else {
        print('FarmerDetails2 data not found for farmId: ${widget.farmId}');
      }

      documentSnapshot = await FirebaseFirestore.instance
          .collection(subfolder)
          .doc('FarmerDetails3')
          .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        setState(() {
          _numberOfVariety = data?['numberOfVarieties'] ?? '';
          _numberOfTrees = data?['numberOfTrees'] ?? '';
          _selectedIrrigationMethod = data?['irrigationMethod'] ?? '';
          _yield = data?['yieldInPreviousYear'] ?? '';
        });
      } else {
        print('FarmerDetails3 data not found for farmId: ${widget.farmId}');
      }

      QuerySnapshot<Map<String, dynamic>> mangoVarietiesSnapshot =
          await FirebaseFirestore.instance
              .collection(subfolder)
              .doc('FarmerDetails4')
              .collection("MangoVarieties")
              .get();

      if (mangoVarietiesSnapshot.docs.isNotEmpty) {
        setState(() {
          mangoVarieties = mangoVarietiesSnapshot.docs;
        });
      } else {
        print('MangoVarieties data not found for farmId: ${widget.farmId}');
      }

      QuerySnapshot<Map<String, dynamic>> cropVarietiesSnapshot =
          await FirebaseFirestore.instance
              .collection(subfolder)
              .doc('OtherPlantDetails1')
              .collection("CropVarieties")
              .get();

      if (mangoVarietiesSnapshot.docs.isNotEmpty) {
        setState(() {
          cropVarieties = cropVarietiesSnapshot.docs;
        });
      } else {
        print('CropVarieties data not found for farmId: ${widget.farmId}');
      }
    } catch (e) {
      print('Error fetching farm data: $e');
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
            Navigator.pop(context);
          },
        ),
        title: Text('Farm Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Visibility(
            visible: _farmName.isNotEmpty ||
                _phoneNumber.isNotEmpty ||
                _addressLine1.isNotEmpty ||
                _addressLine2.isNotEmpty,
            child: Column(
              children: [
                DataDisplaySection(
                  heading: 'Farmer Details 1',
                  dataLabels: [
                    'Farmer name: $_farmName',
                    'Phone number: $_phoneNumber',
                    'Farm Address Line1: $_addressLine1',
                    'Farm Address Line2: $_addressLine2',
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                    height: 1, color: Colors.black), // Horizontal line
                const SizedBox(height: 10),
              ],
            ),
          ),
          Visibility(
            visible: _farmLand.isNotEmpty ||
                _mangoArea.isNotEmpty ||
                _otherCropsArea.isNotEmpty ||
                _locationData.isNotEmpty,
            child: Column(
              children: [
                DataDisplaySection(
                  heading: 'Farmer Details 2',
                  dataLabels: [
                    'Farm Land: $_farmLand',
                    'Area(Mangoes): $_mangoArea',
                    'Area(Other crops): $_otherCropsArea',
                    'Location: $_locationData',
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                    height: 1, color: Colors.black), // Horizontal line
                const SizedBox(height: 10),
              ],
            ),
          ),
          Visibility(
            visible: _numberOfVariety.isNotEmpty ||
                _numberOfTrees.isNotEmpty ||
                _selectedIrrigationMethod.isNotEmpty ||
                _yield.isNotEmpty,
            child: Column(
              children: [
                DataDisplaySection(
                  heading: 'Mango Details',
                  dataLabels: [
                    'Number of Varieties: $_numberOfVariety',
                    'Number of Trees: $_numberOfTrees',
                    'Irrigation Method: $_selectedIrrigationMethod',
                    'Yield in Previous Year: $_yield',
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                    height: 1, color: Colors.black), // Horizontal line
                const SizedBox(height: 10),
              ],
            ),
          ),
          Visibility(
            visible: mangoVarieties.isNotEmpty,
            child: Column(
              children: mangoVarieties.asMap().entries.map((entry) {
                var index = entry.key;
                var mangoVarietyData = entry.value.data();
                return Column(
                  children: [
                    DataDisplaySection(
                      heading: 'Mango Variety ${index + 1}',
                      dataLabels: [
                        'Mango Variety: ${mangoVarietyData?['name']}',
                        'Area: ${mangoVarietyData?['area']}',
                        'Tree Count: ${mangoVarietyData?['treeCount']}',
                        'Age of Trees: ${mangoVarietyData?['ageOfTrees']}',
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (index <=
                        mangoVarieties.length -
                            1) // Add Divider if not the last item
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ),
          Visibility(
            visible: cropVarieties.isNotEmpty,
            child: Column(
              children: cropVarieties.asMap().entries.expand((entry) {
                var index = entry.key;
                var cropVarietyData = entry.value.data();
                return [
                  DataDisplaySection(
                    heading: 'Crop Variety ${index + 1}',
                    dataLabels: [
                      'Crop Name: ${cropVarietyData?['cropName']}',
                      'Area Utilized: ${cropVarietyData?['areaUtilized']}',
                      'Count of Plants: ${cropVarietyData?['CountOfPlants']}',
                      'Irrigation Method: ${cropVarietyData?['irrigationMethod']}',
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (index <
                      cropVarieties.length -
                          1) // Add Divider if not the last item
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                  const SizedBox(height: 10),
                ];
              }).toList(),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImagesPage(farmId: widget.farmId)),
              );
            },
            child: Text('Next'),
          ),
        ),
      ),
    );
  }
}

class DataDisplaySection extends StatelessWidget {
  final String heading;
  final List<String> dataLabels;

  const DataDisplaySection({
    Key? key,
    required this.heading,
    required this.dataLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              dataLabels.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  dataLabels[index],
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
