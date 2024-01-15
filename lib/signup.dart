import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'displayfarms.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController =
      TextEditingController(); // New line

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());

      // Additional actions after successful signup
      print('User registered: ${userCredential.user?.email}');

      // Save user details to Firestore
      await _saveUserDetailsToFirestore(
        userCredential.user?.uid,
        fullNameController.text.trim(),
        phoneNumberController.text.trim(), // New line
        emailController.text.trim(),
      );

      // Navigate to the DisplayFarms screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FarmsPage(),
        ),
      );
    } catch (e) {
      print('Error during email/password sign-up: $e');
      // Handle the error, for example, display an error message
      String errorMessage =
          'An error occurred during signup. Please try again.';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }

      _showErrorDialog(context, errorMessage);
    }
  }

  Future<void> _saveUserDetailsToFirestore(
      String? userId, String fullName, String phoneNumber, String email) async {
    try {
      // Extract the first 5 letters of the document name as the unique ID
      String uniqueId = userId!.substring(0, 6);

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fullName': fullName,
        'phoneNumber': phoneNumber, // New line
        'email': email,
        'uniqueId': uniqueId,
        // Add other user details as needed
      });

      print('User details saved to Firestore with Unique ID: $uniqueId');
    } catch (e) {
      print('Error saving user details to Firestore: $e');
    }
  }

  Widget _buildTextFieldWithLabel(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(color: Colors.white70),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Signup Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  
    /*
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0EA73C), Color(0xFF12600B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle,
                        size: 100.0, color: Colors.white),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    _buildTextFieldWithLabel('Full Name', fullNameController),
                    _buildTextFieldWithLabel(
                        'Phone Number', phoneNumberController), // New line
                    _buildTextFieldWithLabel('Email', emailController),
                    _buildTextFieldWithLabel(
                        'Password', passwordController),
                    ElevatedButton(
                      onPressed: () async {
                        await _signUpWithEmailAndPassword(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffffffff),
                      ),
                      child: const Text('Continue',
                          style: TextStyle(color: Color(0xFF006227))),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigate to the login page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Already have an account? Log in',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    */
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Color.fromARGB(255, 255, 255, 255),
        onPressed: () {
          Navigator.pop(context);
        
        },
      ),
      backgroundColor:Color(0xFF0EA73C),
      elevation: 0, // Remove the app bar shadow
    ),
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0EA73C), Color(0xFF12600B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle,
                    size: 100.0, color: Colors.white),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                _buildTextFieldWithLabel('Full Name', fullNameController),
                _buildTextFieldWithLabel(
                    'Phone Number', phoneNumberController),
                _buildTextFieldWithLabel('Email', emailController),
                _buildTextFieldWithLabel('Password', passwordController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _signUpWithEmailAndPassword(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffffff),
                  ),
                  child: const Text('Continue',
                      style: TextStyle(color: Color(0xFF006227))),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Already have an account? Log in',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpPage(),
    );
  }
}