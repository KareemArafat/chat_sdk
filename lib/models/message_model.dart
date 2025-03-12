import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MessageModel {
  String senderId;
  String roomId;
  String? text;
  MediaFile? file;

  MessageModel({
    required this.senderId,
    required this.roomId,
    this.text,
    this.file,
  });

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(
      senderId: jsonData['senderId'],
      roomId: jsonData['roomId'],
      text: jsonData['text'],
      file: jsonData['file'] != null
          ? MediaFile.fromJson(jsonData['file'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'roomId': roomId,
        'text': text,
        'file': file?.toJson(),
      };
}

class MediaFile {
  String? path;
  String name;
  String type;
  var base64;
  File? data;
  String? sound;

  MediaFile(this.path, this.name, this.type, this.base64, this.data,this.sound);

  factory MediaFile.fromJson(jsonData) {
    return MediaFile(
      jsonData['path'],
      jsonData['name'],
      jsonData['type'],
      jsonData['base64'],
      jsonData['data'],
      jsonData['sound'],
    );
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'name': name,
        'type': type,
        'base64': base64,
      };
}
