import 'dart:async';

import 'package:chat_sdk/consts.dart';

class RoomsService {
  Future<bool> createRoom({
    required String type,
    required List<String> members,
    String? roomName,
  }) async {
    final completer = Completer<bool>();
    server.socket.emitWithAck(
      'createRoom',
      {'type': type, 'roomName': roomName, 'members': members},
      ack: (response) {
        if (response != null && response['status'] == 'success') {
          completer.complete(true);
        } else {
          completer.complete(false);
        }
      },
    );
    return completer.future;
  }

   void joinRoom(String roomId) {
    server.socket.emit('joinRoom', {'roomId': roomId});
  }
}
