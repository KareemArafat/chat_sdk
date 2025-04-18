import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextBubbleL extends StatelessWidget {
  const TextBubbleL({super.key, required this.o});
  final MessageModel o;
  @override
  Widget build(BuildContext context) {
    String timeFn() {
      String isoString = o.time!;
      DateTime dateTime = DateTime.parse(isoString);
      String formattedTime = DateFormat('hh:mm a').format(dateTime);
      return formattedTime;
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
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  timeFn(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
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
      String isoString = o.time!;
      DateTime dateTime = DateTime.parse(isoString);
      String formattedTime = DateFormat('hh:mm a').format(dateTime);
      return formattedTime;
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
            color: Color.fromARGB(255, 89, 87, 87),
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
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  timeFn(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
