import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/room_model.dart';
import 'package:chat_sdk/services/api_post.dart';

class GetRooms {
  Future<List<RoomModel>?> getRoomsFn({required String userEmail}) async {
    final dataList = await Api().get(url: "$baseUrl/rooms?username=$userEmail");

    List<RoomModel>? roomsList = [];
    for (int i = 0; i < dataList['rooms'].length; i++) {
      roomsList.add(RoomModel.fromJson(dataList['rooms'][i]));
    }
    return roomsList;
  }
}
