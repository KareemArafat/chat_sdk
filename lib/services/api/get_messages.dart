import 'dart:developer';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/services/api/api.dart';

class GetMessages {
  Future<List<MessageModel>?> getMessagesFn({required String userEmail}) async {
    try {
      final dataList =
          await Api().get(url: "$baseUrl/rooms?username=$userEmail");

      List<MessageModel>? messagesList = [];
      for (int i = 0; i < dataList.length; i++) {
        messagesList.add(MessageModel.fromJson(dataList[i]));
      }
      return messagesList;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
