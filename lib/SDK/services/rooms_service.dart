import 'dart:async';
import 'dart:developer';
import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/SDK/models/room_model.dart';
import 'package:chat_sdk/SDK/core/api/api.dart';
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
}
