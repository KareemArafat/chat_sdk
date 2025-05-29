import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/SDK/models/message_model.dart';
import 'package:chat_sdk/SDK/core/api/api.dart';
import 'package:intl/intl.dart';

class MessageService {
  Future<MessageModel> sendMessage(
      {required String mess,
      required String roomId,
      required String senderId}) async {
    MessageModel message =
        MessageModel(senderId: senderId, roomId: roomId, text: mess);
    final completer = Completer<void>();
    server.socket.emitWithAck('sendMessage', message.toJson(), ack: (data) {
      message.messageId = data['messageId'];
      completer.complete();
    });
    await completer.future;
    return message;
  }

  Future<MessageModel> sendFiles(
      {required String roomId,
      required Uint8List bytesFile,
      required String name,
      required String type,
      required String senderId}) async {
    final message = MessageModel(
        senderId: senderId,
        roomId: roomId,
        fileTime: DateFormat('hh:mm a').format(DateTime.now()),
        file: MediaFile(
          dataSend: bytesFile,
          type: type, // 'image'  'video'  'sound'  'record'  'file',
          name: name,
        ));
    final completer = Completer<void>();
    server.socket.emitWithAck('uploadFiles', message.toJson(), ack: (data) {
      message.messageId = data['messageId'];
      completer.complete();
    });
    await completer.future;
    return message;
  }

  Future<Uint8List?> downloadFiles(
      {required String path, required String token}) async {
    try {
      final dataList = await Api()
          .getFile(url: "$baseUrl/download?path=$path&&token=$token");
      return dataList;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  MessageModel? receiveMessages({required String senderId}) {
    MessageModel? message;
    server.socket.on('message', (data) {
      if (senderId != data['senderId']) {
        message = MessageModel.fromJson(data);
      }
    });
    return message;
  }

  void sendReact({required String messageId, required String react}) {
    server.socket.emit('sendReact', {'messageId': messageId, 'react': react});
  }

  String? receiveReact() {
    String? react;
    server.socket.on('receiveReact', (data) {
      react = data;
    });
    return react;
  }

  Future<String> aiMessage({
    required String message,
  }) async {
    final responseData = await Api().post(
      url: "http://localhost:3000/chat",
      body: {
        'message': message,
      },
    );
    return responseData;
  }
}
