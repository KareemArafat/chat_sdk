import 'dart:async';
import 'dart:typed_data';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
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

  MessageModel? receiveMessages({required String senderId}) {
    MessageModel? message;
    server.socket.on('message', (data) {
      if (senderId != data['senderId']) {
        message = MessageModel.fromJson(data);
      }
    });
    return message;
  }
}
