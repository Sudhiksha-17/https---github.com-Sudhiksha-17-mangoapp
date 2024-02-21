import 'package:flutter/material.dart';
import 'package:mangoapp/displayfarms.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'resetemail.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FarmsPage()),
      );
    } catch (e) {
      print('Error during email/password sign in: $e');
      // Handle the error, for example, display an error message
      String errorMessage = 'An error occurred during login. Please try again.';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }

      _showErrorDialog(context, errorMessage);
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg_login.jpg"),
                fit: BoxFit.cover,
                opacity: 0.5),
          ),
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'LogIn',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextFieldWithLabel(
                      'Email',
                      controller: _emailController,
                    ),
                    _buildTextFieldWithLabel(
                      'Password',
                      controller: _passwordController,
                      isPassword: true,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage2()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          _signInWithEmailAndPassword(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 246, 199, 12),
                      ),
                      child: const Text('Continue',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
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
  }

  Widget _buildTextFieldWithLabel(
    String label, {
    TextEditingController? controller,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(color: Colors.black),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: const TextStyle(color: Colors.black),
            obscureText: isPassword,
          ),
        ],
      ),
    );
  }
}
