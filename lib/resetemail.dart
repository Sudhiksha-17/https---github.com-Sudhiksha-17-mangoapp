import 'package:flutter/material.dart';
import 'confirmpass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage2 extends StatelessWidget {
  LoginPage2({Key? key}) : super(key: key);

  late final TextEditingController _emailController = TextEditingController();

  Future<void> _sendPasswordResetEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );

      // Navigate to ResetPasswordPage and pass the email
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(email: _emailController.text),
        ),
      );
    } catch (e) {
      print('Error sending password reset email: $e');
      // Handle the error, for example, display an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            children: [
              _buildTextFieldWithLabel(
                'Enter your registered Email ID',
                controller: _emailController,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_emailController.text.isNotEmpty) {
                    _sendPasswordResetEmail(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffffffff),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Color(0xFF006227)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(
    String label, {
    TextEditingController? controller,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
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
            obscureText: isPassword,
          ),
        ],
      ),
    );
  }
}
