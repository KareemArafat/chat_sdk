import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/cubits/rooms_cubit/rooms_cubit.dart';
import 'package:chat_sdk/services/socket/socket_service.dart';
import 'package:chat_sdk/ui/custom_ui/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void addGroupChat(BuildContext context, SocketService socketService) {
  String groupName = '';
  Map<int, String> users = {};

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: baseAppBarColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Group Name',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              CustomField(
                hint: 'Enter group name',
                change: (p0) => groupName = p0,
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Add Users',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: CustomField(
                        hint: 'Enter user id',
                        change: (p0) => users[index] = p0,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      List<String> filledUsers = users.values
                          .where((name) => name.trim().isNotEmpty)
                          .toList();
                      Navigator.of(context).pop();
                      BlocProvider.of<RoomsCubit>(context).addRoom(
                          socketService: socketService,
                          user: filledUsers,
                          name: groupName,
                          type: 'group');
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
