import 'package:flutter/material.dart';
import 'package:mangoapp/displayfarms2.dart'; // Replace with your actual import
import 'package:mangoapp/process.dart'; // Replace with your actual import

class Disp3Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose'),
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
                      builder: (context) => DisplayPage(
                          farmId:
                              'your actual id'), // Replace with the actual farmId
                    ),
                  );
                },
                child: Text(
                  'View Farm Details',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProcessPage(),
                    ),
                  );
                },
                child: Text(
                  'Processes at Farms',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
