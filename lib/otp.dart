import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'displayfarms.dart';

class OtpScreen extends StatefulWidget {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String verificationId; // Declare verificationId here

  const OtpScreen({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.verificationId, // Accept verificationId as a parameter
    Key? key,
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late List<TextEditingController> _otpControllers;
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (index) => TextEditingController());
    _initiatePhoneNumberSignIn();
  }

  void _initiatePhoneNumberSignIn() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: _verificationCompleted,
        verificationFailed: _verificationFailed,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      );
    } catch (e) {
      print('Error during phone number sign-in initiation: $e');
    }
  }

  void _verificationCompleted(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Perform actions after successful verification
      // For example, you might navigate to the next screen
    } catch (e) {
      print('Error during phone number sign-in: $e');
    }
  }

  void _verificationFailed(FirebaseAuthException e) {
    print('Verification Failed: ${e.message}');

    // Handle the verification failure (e.g., show an error message)
  }

  void _codeSent(String verificationId, int? resendToken) {
    // Save verification ID
    _verificationId = verificationId;
    print('Verification ID: $_verificationId');
  }

  void _codeAutoRetrievalTimeout(String verificationId) {
    // Handle the timeout, if necessary
  }

  Future<void> _saveUserData() async {
    try {
      // Extract the OTP entered by the user from the controllers
      String enteredOtp =
          _otpControllers.map((controller) => controller.text).join();

      // Check if entered OTP is valid
      if (enteredOtp.length == 6) {
        // Use the entered OTP for verification
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: enteredOtp,
        );

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(phoneAuthCredential);

        // Get the authenticated user
        User? user = userCredential.user;

        if (user != null) {
          // Save user details in Firestore
          Map<String, dynamic> userData = {
            'fullName': widget.fullName,
            'email': widget.email,
            'phoneNumber': widget.phoneNumber,
          };

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userData);

          // Navigate to the next page after successful authentication and data save
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FarmsPage(),
            ),
          );
        } else {
          // Display an error message if user is not authenticated
          print('User not authenticated');
          // You can add UI feedback here to inform the user about the issue
        }
      } else {
        // Display an error message for incorrect OTP length
        print('Incorrect OTP');
        // You can add UI feedback here to inform the user about the incorrect OTP
      }
    } catch (e) {
      // Handle errors during OTP verification
      print('Error during OTP verification: $e');
      // You can add UI feedback here to inform the user about the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0EA73C), Color(0xFF12600B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Enter 6 digit verification code\nsent to your registered mobile number.',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => _buildOtpTextField(_otpControllers[index], index),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _saveUserData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffffff),
                  ),
                  child: const Text('Submit',
                      style: TextStyle(color: Color(0xFF006227))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpTextField(TextEditingController controller, int index) {
    return Container(
      width: 35.0,
      height: 48.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18.0),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
