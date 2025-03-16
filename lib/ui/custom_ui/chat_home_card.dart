import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/pages/chat_page.dart';
import 'package:chat_sdk/shardP/shard_p_model.dart';
import 'package:flutter/material.dart';

class ChatHomeCard extends StatelessWidget {
  const ChatHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String token = await ShardpModel().getToken();
        String id = await ShardpModel().getSenderId();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatPage(
            token: token,
            id: id,
          );
        }));
      },
      child: const Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/user_image.jpg'),
            ),
            title: Text(
              'name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'message content',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            trailing: Text(
              '8:00',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Divider(
              color: baseColor1,
              thickness: 0.5,
              indent: 60,
              endIndent: 60,
            ),
          )
        ],
      ),
    );
  }
}
