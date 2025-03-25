import 'dart:io';
import 'package:file_picker/file_picker.dart';

class MessageModel {
  String senderId;
  String roomId;
  //DateTime time;
  String? text;
  MediaFile? file;

  MessageModel({
    required this.senderId,
    required this.roomId,
    //  required this.time,
    this.text,
    this.file,
  });

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(
      senderId: jsonData['senderId'],
      roomId: jsonData['roomId'],
      //     time: DateTime.parse(jsonData['time']),
      text: jsonData['text'],
      file: jsonData['file'] != null
          ? MediaFile.fromJson(jsonData['file'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'roomId': roomId,
        //     'time': time,
        'text': text,
        'file': file?.toJson(),
      };
}

class MediaFile {
  // ignore: prefer_typing_uninitialized_variables
  var dataSend;
  String? path;
  String name;
  String type;
  File? videoData;
  FilePickerResult? soundData;
  String? recordData;

  MediaFile(this.dataSend, this.path, this.name, this.type, this.videoData,
      this.soundData, this.recordData);

  factory MediaFile.fromJson(jsonData) {
    return MediaFile(
      jsonData['data'],
      jsonData['path'],
      jsonData['name'],
      jsonData['type'],
      jsonData['videoData'],
      jsonData['soundData'],
      jsonData['recordData'],
    );
  }

  Map<String, dynamic> toJson() => {
        'data': dataSend,
        'path': path,
        'name': name,
        'type': type,
      };
}
