import 'dart:io';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  sendMess(
      {required Socket socket,
      required String mess,
      required String roomId}) async {
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
      senderId: id,
      roomId: roomId,
      text: mess,
    );
    socket.emit('sendMessage', message.toJson());
    emit(ChatSuccess(mess: message));
  }

  sendImage(
      {required Socket socket,
      required ImageSource source,
      required String roomId}) async {
    final returnedImage = await ImagePicker().pickImage(source: source);
    if (returnedImage == null) return;
    File imgFile = File(returnedImage.path);
    final imageBytes = imgFile.readAsBytesSync();
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
        senderId: id,
        roomId: roomId,
        fileTime: DateFormat('hh:mm a').format(DateTime.now()),
        file: MediaFile(
          dataSend: imageBytes,
          type: 'image',
          name: returnedImage.name,
        ));
    socket.emit('uploadFiles', message.toJson());
    emit(ChatSuccess(mess: message));
  }

  sendVideo(
      {required Socket socket,
      required ImageSource source,
      required String roomId}) async {
    final returnedVideo = await ImagePicker().pickVideo(source: source);
    if (returnedVideo == null) return;
    File videoFile = File(returnedVideo.path);
    final videoBytes = videoFile.readAsBytesSync();
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
        senderId: id,
        roomId: roomId,
        fileTime: DateFormat('hh:mm a').format(DateTime.now()),
        file: MediaFile(
          dataSend: videoBytes,
          name: returnedVideo.name,
          type: 'video',
        ));
    socket.emit('uploadFiles', message.toJson());
    emit(ChatSuccess(mess: message));
  }

  sendSound({required Socket socket, required String roomId}) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return;
    File file = File(result.files.single.path!);
    List<int> audioBytes = await file.readAsBytes();
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
      //   time: DateTime.now(),
      senderId: id,
      roomId: roomId,
      file: MediaFile.fromJson({
        'data': audioBytes,
        'name': result.files.single.name,
        'type': 'sound',
        'soundData': result,
      }),
    );
    socket.emit('uploadFiles', message.toJson());
    emit(ChatSuccess(mess: message));
  }

  sendFile({required Socket socket, required String roomId}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'txt',
          'docx',
          'doc',
          'ppt',
          'pptx',
          'xlsx'
        ]);
    if (result == null) return;
    File file = File(result.files.single.path!);
    final fileBytes = await file.readAsBytes();
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
        //   time: DateTime.now(),
        senderId: id,
        roomId: roomId,
        file: MediaFile(
          dataSend: fileBytes,
          name: result.files.single.name,
          type: 'file',
        ));
    socket.emit('uploadFiles', message.toJson());
    emit(ChatSuccess(mess: message));
  }

  sendRecord(
      {required Socket socket,
      required String path,
      required String roomId}) async {
    File result = File(path);
    final recordBytes = await result.readAsBytes();
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
        senderId: id,
        roomId: roomId,
        fileTime: DateFormat('hh:mm a').format(DateTime.now()),
        file: MediaFile(
          dataSend: recordBytes,
          name: path,
          type: 'record',
        ));
    socket.emit('uploadFiles', message.toJson());
    emit(ChatSuccess(mess: message));
  }

  receiveMess({required Socket socket}) async {
    String id = await ShardpModel().getSenderId();
    socket.on('message', (data) {
      if (id != data['sender']) {
        emit(ChatSuccess(mess: MessageModel.fromJson(data)));
      }
    });
  }
}
