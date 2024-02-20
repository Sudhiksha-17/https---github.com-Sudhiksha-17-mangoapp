import 'package:flutter/material.dart';
import 'package:mangoapp/processes/landprep.dart'; // Import your actual page
import 'package:mangoapp/processes/varietyselect.dart'; // Import your actual page
import 'package:mangoapp/processes/planting.dart'; // Import your actual page
import 'package:mangoapp/processes/mulch.dart'; // Import your actual page
import 'package:mangoapp/processes/pruning.dart'; // Import your actual page
//import 'package:mangoapp/processes/soiltest.dart'; // Import your actual page
import 'package:mangoapp/processes/irrigation.dart'; // Import your actual p
import 'package:mangoapp/processes/fertilizer.dart'; // Import your actual page
import 'package:mangoapp/processes/pest.dart'; // Import your actual page
import 'package:mangoapp/processes/farminspect.dart'; // Import your actual page
//import 'package:mangoapp/processes/harvest.dart'; // Import your actual page

class ProcessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Processes at Farms'),
        backgroundColor: Color(0xffffc900).withOpacity(0.7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg_login.jpg"),
              fit: BoxFit.cover,
              opacity: 0.5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LandPreparationPage(),
                    ),
                  );
                },
                child: Text(
                  'Land Preparation',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VarietySelectionPage(),
                    ),
                  );
                },
                child: Text(
                  'Mango Variety Selection',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantingPage(),
                    ),
                  );
                },
                child: Text(
                  'Planting',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MulchingPage(),
                    ),
                  );
                },
                child: Text(
                  'Mulching',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PruningPage(),
                    ),
                  );
                },
                child: Text(
                  'Pruning',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),

              /* ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (),
                  ),
                );
              },
              child: Text('Soil Testing'),
            ), */

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IrrigationPage(),
                    ),
                  );
                },
                child: Text(
                  'Irrigation',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FertilizerPage(),
                    ),
                  );
                },
                child: Text(
                  'Fertilization',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PestPage(),
                    ),
                  );
                },
                child: Text(
                  'Pest & Disease Management',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FarmInspectPage(),
                    ),
                  );
                },
                child: Text(
                  'Regular Farm Inspection',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),

              /* ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HarvestPage(),
                  ),
                );
              },
              child: Text('Harvest'),
            ), */
            ],
          ),
        ),
      ),
    );
  }
}
