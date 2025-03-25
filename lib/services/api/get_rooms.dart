import 'dart:developer';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/room_model.dart';
import 'package:chat_sdk/services/api/api.dart';

class GetRooms {
  Future<List<RoomModel>?> getRoomsFn({required String userEmail}) async {
    try {
      final dataList =
          await Api().get(url: "$baseUrl/rooms?username=$userEmail");
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
