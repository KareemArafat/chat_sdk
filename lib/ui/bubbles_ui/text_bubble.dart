import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/ui/bubbles_ui/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextBubble extends StatelessWidget {
  const TextBubble({super.key, required this.o, required this.isMe});
  final MessageModel o;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.bottomLeft : Alignment.bottomRight, // **
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(30),
              topRight: const Radius.circular(30),
              bottomRight: isMe ? const Radius.circular(30) : Radius.zero, // **
              bottomLeft: isMe ? Radius.zero : const Radius.circular(30), // **
            ),
            color: isMe ? baseColor1 : baseAppBarColor, // **
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 50),
                child: Text(
                  o.text!,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              TimeWidget(time: timeFn()),
            ],
          ),
        ),
      ),
    );
  }

  String timeFn() {
    if (o.time == null) {
      o.time = DateFormat('hh:mm a').format(DateTime.now());
      return o.time!;
    } else if (o.time!.length > 10) {
      DateTime dateTime = DateTime.parse(o.time!);
      o.time = DateFormat('hh:mm a').format(dateTime);
      return o.time!;
    } else {
      return o.time!;
    }
  }
}
