import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Ensure that the LoginPage is imported

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Display a splash screen for 3 seconds and then navigate to the login page
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,  // Background color for splash screen
      body: Center(
        child: Image.asset(
          'assets/logo.png',  // Ensure the logo image is stored in the assets folder
          width: 200,  // You can adjust the size of the logo
          height: 200,
        ),
      ),
    );
  }
}
