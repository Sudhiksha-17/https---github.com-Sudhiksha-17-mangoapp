import 'package:flutter/material.dart';
import 'package:mangoapp/displayfarms.dart';

class FarmAddedSuccessPage extends StatelessWidget {
  const FarmAddedSuccessPage({super.key});

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
      ),
      body: Container(
        color: Color(0xffffffff),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF006227),
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Farm was added successfully!!',
                style: TextStyle(
                  color: Color(0xFF006227),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),*/
              GestureDetector(
                onTap: () {
                  // Navigate to the AddFarms2Page when the add icon is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FarmsPage()),
                  );
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF006227),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Farm was added successfully!!',
                style: TextStyle(
                  color: Color(0xFF006227),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
              onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FarmsPage()),
                  );},
              child:
                  Text('Back to Home', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff02c44f),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
