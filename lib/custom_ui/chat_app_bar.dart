import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/user_image.jpg'),
          ),
        ),
        const Spacer(flex: 1),
        const Text(
          'User',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        const Spacer(
          flex: 3,
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
      ],
    );
  }
}
