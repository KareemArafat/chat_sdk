import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/pages/chat_page.dart';
import 'package:chat_sdk/ui/custom_field.dart';
import 'package:flutter/material.dart';

void addChat(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: baseAppBarColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomField(
                hint: 'Enter user id',
                submit: (p0) {},
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ChatPage(token: 'token'),
                          ));
                    },
                    child: const Text(
                      'Create Chat',
                      style: TextStyle(color: baseColor1),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close',
                        style: TextStyle(color: baseColor1)),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
