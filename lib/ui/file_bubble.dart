import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class FileBubble extends StatelessWidget {
  const FileBubble({super.key, required this.o});
  final MessageModel o;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        OpenFilex.open(o.file!.recordData);
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Container(
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: baseColor1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.file_copy, color: Colors.white),
                SizedBox(width: 8),
                Text('Open', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
