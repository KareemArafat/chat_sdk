import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/ui/bubbles_ui/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextBubbleL extends StatelessWidget {
  const TextBubbleL({super.key, required this.o});
  final MessageModel o;
  @override
  Widget build(BuildContext context) {
    String timeFn() {
      if (o.time == null) {
        //  String isoString = DateTime.now();
        //   DateTime dateTime = DateTime.parse(isoString);
        String formattedTime = DateFormat('hh:mm a').format(DateTime.now());
        o.time = formattedTime;
        return o.time!;
      } else {
        return o.time!;
      }
    }

    return Align(
      alignment: Alignment.bottomLeft,
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            color: baseColor1,
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
}

class TextBubbleR extends StatelessWidget {
  const TextBubbleR({super.key, required this.o});
  final MessageModel o;
  @override
  Widget build(BuildContext context) {
    String timeFn() {
      if (o.time!.length > 10) {
        String isoString = o.time!;
        DateTime dateTime = DateTime.parse(isoString);
        String formattedTime = DateFormat('hh:mm a').format(dateTime);
        o.time = formattedTime;
        return o.time!;
      } else {
        return o.time!;
      }
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30)),
            color: baseAppBarColor,
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
}
