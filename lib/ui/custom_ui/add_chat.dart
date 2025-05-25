import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/cubits/rooms_cubit/rooms_cubit.dart';
import 'package:chat_sdk/services/socket/socket_service.dart';
import 'package:chat_sdk/ui/custom_ui/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void addChat(BuildContext context, SocketService socketService) {
  String user = '';
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: baseAppBarColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomField(
                hint: 'Enter user id',
                change: (p0) => user = p0,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      BlocProvider.of<RoomsCubit>(context).addRoom(
                          socketService: socketService,
                          user: [user],
                          type: 'direct');
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
