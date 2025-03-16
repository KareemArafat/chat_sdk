import 'dart:io';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:flutter/material.dart';

class ImageBubbleL extends StatelessWidget {
  const ImageBubbleL({super.key, required this.o});
  final MessageModel o;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
          height: MediaQuery.of(context).size.height / 3.2,
          width: MediaQuery.of(context).size.width / 2,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            color: baseColor1,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                child: Image.memory(
                  o.file!.base64,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageBubbleR extends StatelessWidget {
  const ImageBubbleR({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          height: MediaQuery.of(context).size.height / 3.2,
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(249, 158, 155, 162)),
          child: Card(
            child: Image.file(File(imagePath)),
          ),
        ),
      ),
    );
  }
}
