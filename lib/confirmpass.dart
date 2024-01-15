import 'package:flutter/material.dart';
import 'login.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({Key? key, required this.email}) : super(key: key);

  final String email;
  late final TextEditingController _newPasswordController =
      TextEditingController();
  late final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _submitNewPassword(BuildContext context) {
    try {
      if (_newPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty) {
        if (_newPasswordController.text == _confirmPasswordController.text) {
          // Password reset successful, navigate to LoginPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // Passwords don't match, show an error or display a snackbar
          print('Passwords do not match');
        }
      }
    } catch (e) {
      print('Error resetting password: $e');
      // Handle the error, show an error message or display a snackbar
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50.0),
              const Icon(Icons.lock_open, size: 100.0, color: Colors.white),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              _buildTextFieldWithLabel(
                'Enter New Password',
                controller: _newPasswordController,
                isPassword: true,
              ),
              _buildTextFieldWithLabel(
                'Confirm New Password',
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  _submitNewPassword(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffffffff),
                ),
                child: const Text('Submit',
                    style: TextStyle(color: Color(0xFF006227))),
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
