import 'dart:io';
import 'package:file_picker/file_picker.dart';

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
  // ignore: prefer_typing_uninitialized_variables
  var base64;
  String? path;
  String name;
  String type;
  File? videoData;
  FilePickerResult? soundData;
  String? recordData;

  MediaFile(this.base64, this.path, this.name, this.type, this.videoData,
      this.soundData, this.recordData);

  factory MediaFile.fromJson(jsonData) {
    return MediaFile(
      jsonData['base64'],
      jsonData['path'],
      jsonData['name'],
      jsonData['type'],
      jsonData['videoData'],
      jsonData['soundData'],
      jsonData['recordData'],
    );
  }

  Map<String, dynamic> toJson() => {
        'base64': base64,
        'path': path,
        'name': name,
        'type': type,
      };
}
