import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.cyan,
          child: Center(
            child: Image.asset('assets/splash_logo.png'),
          ),
        ),
      ),
    );
  }
}
