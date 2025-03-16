import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:flutter/material.dart';

class TextBubbleL extends StatelessWidget {
  const TextBubbleL({super.key, required this.o});
  final MessageModel o;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            color: baseColor1,
          ),
          child: Center(
              child: Text(
            o.text!,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          )),
        ),
      ),
    );
  }
}

class ChatBubbleR extends StatelessWidget {
  const ChatBubbleR({super.key, required this.o});
  final MessageModel o;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30)),
            color: Color.fromARGB(250, 186, 172, 200),
          ),
          child: Center(
              child: Text(
            o.text!,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          )),
        ),
      ),
    );
  }
}
