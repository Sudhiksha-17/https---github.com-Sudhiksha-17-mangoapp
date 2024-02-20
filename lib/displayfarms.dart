import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mangoapp/add1.dart';
import 'package:mangoapp/disp3.dart';
import 'package:mangoapp/login.dart';

class FarmsPage extends StatefulWidget {
  @override
  _FarmsPageState createState() => _FarmsPageState();
}

class _FarmsPageState extends State<FarmsPage> {
  List<String> farmIds = [];
  static int farmCount = 1;

  @override
  void initState() {
    super.initState();
    _loadFarmIds();
  }

  void _loadFarmIds() async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('FarmDetails')
          .doc('farmIds')
          .get();

      if (snapshot.exists) {
        setState(() {
          farmIds = List<String>.from(snapshot.data()?['ids'] ?? []);
        });
      }
    }
  }

  void _saveFarmIds() async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('FarmDetails')
          .doc('farmIds')
          .set({'ids': farmIds});
    }
  }

  Future<String> _generateFarmId(String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('FarmDetails')
        .doc('farmIds')
        .get();

    List<String> farmIds = List<String>.from(snapshot.data()?['ids'] ?? []);

    int maxFarmCount = 0;

    farmIds.forEach((farmId) {
      int currentFarmCount = int.parse(farmId.split('_')[1]);
      if (currentFarmCount > maxFarmCount) {
        maxFarmCount = currentFarmCount;
      }
    });

    farmCount = maxFarmCount + 1;

    String farmId =
        '${userId.substring(0, 6)}_${farmCount.toString().padLeft(3, '0')}';

    return farmId;
  }

  void _addFarm() async {
    try {
      var user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return;
      }

      String farmId = await _generateFarmId(user.uid);

      setState(() {
        farmIds.add(farmId);
      });

      _saveFarmIds();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('FarmDetails')
          .doc(farmId)
          .set({});

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddFarmsPage(farmId: farmId),
        ),
      );
    } catch (e) {
      print('Error adding farm: $e');
    }
  }

  void _navigateToFarmPage(String farmId) async {
    DocumentSnapshot farmSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('FarmDetails')
        .doc(farmId)
        .get();

    if (farmSnapshot.exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Disp3Page(),
        ),
      );
    } else {
      print('Farm data not found for farmId: $farmId');
    }
  }

  void _removeFarmBox(String farmId) async {
    setState(() {
      farmIds.removeWhere((id) => id == farmId);
    });

    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collectionGroup(farmId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          document.reference.delete();
        });
      });

      _saveFarmIds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farms App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Farms',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.yellow.withOpacity(0.7),
          actions: [
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg_login.jpg"),
                fit: BoxFit.cover,
                opacity: 0.7),
          ),
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _addFarm,
                  child: Text('Add Farm'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: farmIds.length,
                    itemBuilder: (context, index) {
                      return _buildFarmBox(farmIds[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFarmBox(String farmId) {
    return Card(
      margin: EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 91, 198, 58),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                _navigateToFarmPage(farmId);
              },
              child: Text('Farm ID: $farmId'),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _navigateToEditFarmPage(farmId);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(farmId);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String farmId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete farm?'),
          content: Text('Are you sure you want to delete this farm?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeFarmBox(farmId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 234, 89, 79),
              ),
              child: Text(
                'Confirm',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditFarmPage(String farmId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFarmsPage(farmId: farmId),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FarmsPage(),
  ));
}
