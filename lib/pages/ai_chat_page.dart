import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/ui/bubbles_ui/text_bubble.dart';
import 'package:chat_sdk/ui/custom_ui/chat_bottom_field.dart';
import 'package:flutter/material.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  List<MessageModel> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: MediaQuery.of(context).size.height / 13,
        backgroundColor: baseAppBarColor,
        title: Row(
          children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 6, right: 15),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/ai_icon.jpg'),
                )),
            Text('Ai Chat',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.055))
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.white)),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset("assets/images/chat_image.jpg",
                  fit: BoxFit.cover)),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return TextBubbleL(o: message);
                  },
                ),
              ),
              const ChatBottomField(
                aiChat: true,
              )
            ],
          ),
        ],
      ),
    );
  }
}
