import 'dart:async';

import 'package:flutter/material.dart';
import 'package:object_detection_ai/ui/screens/home_screen.dart';
import 'package:object_detection_ai/value/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Timer timer;

  @override
  void initState() {
    timer = Timer(
      Duration(seconds: 2),
      () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false,
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorDarkMode,
      body: Center(
        child: Image.asset(
          "assets/images/logo.png",
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
