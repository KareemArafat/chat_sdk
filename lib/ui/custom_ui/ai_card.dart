import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/pages/ai_chat_page.dart';
import 'package:flutter/material.dart';

class AiCard extends StatelessWidget {
  const AiCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AiChatPage(),
            ));
          },
          child: ListTile(
            minTileHeight: MediaQuery.of(context).size.height / 13,
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/ai_icon.jpg'),
            ),
            title: const Text(
              'Ai Chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Divider(
            color: baseColor1,
            thickness: 0.5,
            indent: 60,
            endIndent: 60,
          ),
        )
      ],
    );
  }
}
