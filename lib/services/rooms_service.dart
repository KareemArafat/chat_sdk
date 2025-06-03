import 'dart:async';
import 'dart:developer';
import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/models/room_model.dart';
import 'package:chat_sdk/core/api/api.dart';
import 'package:chat_sdk/core/shardP/shard_p_model.dart';

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

  Future<List<RoomModel>?> getRooms() async {
    String userId = await ShardpModel().getUserId();
    try {
      final dataList = await Api().get(url: "$baseUrl/rooms?userId=$userId");
      List<RoomModel>? roomsList = [];
      for (int i = 0; i < dataList['rooms'].length; i++) {
        roomsList.add(RoomModel.fromJson(dataList['rooms'][i]));
      }
      return roomsList;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  void typingCheck(
      {required void Function(String userId, bool typing) typingFn}) {
    server.socket.on(
      'isTyping',
      (data) {
        typingFn(data['userId'], data['isTyping']);
      },
    );
  }

  void typing(String roomId, bool isTyping) {
    server.socket.emit('isTyping', {'roomId': roomId, 'isTyping': isTyping});
  }

  void onlineCheck(
      {required void Function(String userId, bool online) onlineFn}) {
    server.socket.on(
      'isOnline',
      (data) {
        onlineFn(data['userId'], data['isOnline']);
      },
    );
  }

  void online(String userId) {
    server.socket.emit('isOnline', {'userId': userId});
  }
}
