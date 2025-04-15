import 'package:chat_sdk/consts.dart';
import 'package:flutter/material.dart';

class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseGroundColor,
      body: Center(
        child: Image.asset(
          'assets/images/logo_image.png',
          width: 130, // Set width
          height: 130, // Set height
        ),
      ),
    );
  }
}
