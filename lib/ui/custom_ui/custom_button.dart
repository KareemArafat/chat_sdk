import 'package:chat_sdk/consts.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.sign, this.tap});

  final String sign;
  final VoidCallback? tap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25)),
        width: 200,
        height: 50,
        child: Center(
            child: Text(
          sign,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: baseColor1),
        )),
      ),
    );
  }
}
