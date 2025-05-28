import 'package:chat_sdk/core/consts.dart';
import 'package:flutter/material.dart';

class VoiceCallPage extends StatelessWidget {
  const VoiceCallPage({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseAppBarColor,
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 3),
            const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/images/user_image.jpg'),
            ),
            const Spacer(flex: 1),
            Text(
              name,
              style: const TextStyle(fontSize: 30, color: Colors.white),
            ),
            const Spacer(flex: 5),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close_sharp)),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
