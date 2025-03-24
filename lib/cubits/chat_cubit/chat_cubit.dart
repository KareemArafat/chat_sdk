import 'dart:io';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/shardP/shard_p_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  List<MessageModel> cubitMessageList = [];
  String roomId = '674a0b28628dfde5ad21f103';

  sendMess({required Socket socket, required String mess}) async {
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
      senderId: id,
      roomId: roomId,
  
      text: mess,
    );
    cubitMessageList.add(message);
    socket.emit('sendMessage', message.toJson());
    emit(ChatSuccess(messagesList: List.from(cubitMessageList)));
  }

  sendImage({required Socket socket, required ImageSource source}) async {
    final returnedImage = await ImagePicker().pickImage(source: source);
    if (returnedImage == null) return;
    File imgFile = File(returnedImage.path);
    List<int> imageBytes = imgFile.readAsBytesSync();
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
    //  time: DateTime.now(),
      senderId: id,
      roomId: roomId,
      file: MediaFile.fromJson({
        'base64': imageBytes,
        'name': returnedImage.name,
        'type': 'image',
      }),
    );
    socket.emit('uploadFiles', message.toJson());
    cubitMessageList.add(message);
    emit(ChatSuccess(messagesList: cubitMessageList));
  }

  sendVideo({required Socket socket, required ImageSource source}) async {
    final returnedVideo = await ImagePicker().pickVideo(source: source);
    if (returnedVideo == null) return;
    File videoFile = File(returnedVideo.path);
    List<int> videoBytes = videoFile.readAsBytesSync();
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
      senderId: id,
      roomId: roomId,
   //   time: DateTime.now(),
      file: MediaFile.fromJson({
        'base64': videoBytes,
        'name': returnedVideo.name,
        'type': 'video',
        'videoData': videoFile
      }),
    );
    socket.emit('uploadFiles', message.toJson());
    cubitMessageList.add(message);
    emit(ChatSuccess(messagesList: cubitMessageList));
  }

  sendSound({required Socket socket}) async {
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
        'base64': audioBytes,
        'name': result.files.single.name,
        'type': 'sound',
        'soundData': result,
      }),
    );
    socket.emit('uploadFiles', message.toJson());
    cubitMessageList.add(message);
    emit(ChatSuccess(messagesList: cubitMessageList));
  }

  sendFile({required Socket socket}) async {
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
    List<int> fileBytes = await file.readAsBytes();
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
   //   time: DateTime.now(),
      senderId: id,
      roomId: roomId,
      file: MediaFile.fromJson({
        'base64': fileBytes,
        'name': result.files.single.name,
        'type': 'file',
        'recordData': result.files.single.path,
      }),
    );
    socket.emit('uploadFiles', message.toJson());
    cubitMessageList.add(message);
    emit(ChatSuccess(messagesList: cubitMessageList));
  }

  sendRecord({required Socket socket, required String path}) async {
    File result = File(path);
    List<int> recordBytes = await result.readAsBytes();
    String id = await ShardpModel().getSenderId();
    final message = MessageModel(
   //   time: DateTime.now(),
      senderId: id,
      roomId: roomId,
      file: MediaFile.fromJson({
        'base64': recordBytes,
        'name': path,
        'type': 'record',
        'recordData': path,
      }),
    );
    socket.emit('uploadFiles', message.toJson());
    cubitMessageList.add(message);
    emit(ChatSuccess(messagesList: cubitMessageList));
  }
}
