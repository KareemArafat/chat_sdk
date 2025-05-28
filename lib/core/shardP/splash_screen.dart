import 'package:chat_sdk/core/consts.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseGroundColor,
      body: Center(
        child: Image.asset(
          'assets/images/logo_image.png',
          height: 180,
        ),
      ),
    );
  }
}
