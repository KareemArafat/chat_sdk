import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/room_model.dart';
import 'package:chat_sdk/pages/chat_page.dart';
import 'package:chat_sdk/services/socket/socket.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatHomeCard extends StatelessWidget {
  const ChatHomeCard(
      {super.key, required this.room, required this.socketService});
  final RoomModel room;
  final SocketService socketService;

  @override
  Widget build(BuildContext context) {
    String timeFn() {
      if (room.lastMessage != null) {
        String isoString = room.lastMessage!.time;
        DateTime dateTime = DateTime.parse(isoString);
        String formattedTime =
            DateFormat('yyyy-MM-dd \n hh:mm a').format(dateTime);
        return formattedTime;
      } else {
        return '';
      }
    }

    String messFn() {
      if (room.lastMessage != null) {
        if (room.lastMessage?.text != null) {
          return room.lastMessage!.text!;
        } else {
          return room.lastMessage!.fileType!;
        }
      } else {
        return '';
      }
    }

    return GestureDetector(
      onTap: () async {
        String id = await ShardpModel().getSenderId();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatPage(
            id: id,
            roomId: room.roomId,
            socketService: socketService,
          );
        }));
      },
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/user_image.jpg'),
            ),
            title: Text(
              room.users!.last,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              messFn(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            trailing: Text(
              timeFn(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
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
      ),
    );
  }
}
