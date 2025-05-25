import 'dart:developer';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/room_model.dart';
import 'package:chat_sdk/services/api/api.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';

class GetRooms {
  Future<List<RoomModel>?> getRoomsFn() async {
    String userId = await ShardpModel().getUserId();
    try {
      final dataList =
          await Api().get(url: "$baseUrl/rooms?userId=$userId");
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
