import 'dart:developer';
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

  sendMess({required Socket socket, required String mess}) async {
    try {
      String id = await ShardpModel().getSenderId();
      final m = MessageModel(
          senderId: id, roomId: '674a0b28628dfde5ad21f103', text: mess);
      cubitMessageList.add(m);
      socket.emit('sendMessage',
          {'senderId': id, 'roomId': '674a0b28628dfde5ad21f103', 'text': mess});
      emit(ChatSuccess(messagesList: List.from(cubitMessageList)));
    } catch (e) {
      log('Failed to send message: $e');
    }
  }

  sendImage({required ImageSource source, required Socket socket}) async {
    try {
      final returnedImage = await ImagePicker().pickImage(source: source);
      if (returnedImage == null) return;
      File imgFile = File(returnedImage.path);
      List<int> imageBytes = imgFile.readAsBytesSync();
      String id = await ShardpModel().getSenderId();
      final m = MessageModel(
        senderId: id,
        roomId: '674a0b28628dfde5ad21f103',
        file: MediaFile.fromJson({
          'name': 'imageName.jpg',
          'type': 'image',
          'base64': imageBytes,
        }),
      );
      socket.emit('uploadFiles', m.toJson());
      cubitMessageList.add(m);
      emit(ChatSuccess(messagesList: cubitMessageList));
    } catch (e) {
      log('Failed to send message: $e');
    }
  }

  sendVideo({required ImageSource source, required Socket socket}) async {
    final returnedVideo = await ImagePicker().pickVideo(source: source);
    if (returnedVideo == null) return;
    File videoFile = File(returnedVideo.path);
    List<int> videoBytes = videoFile.readAsBytesSync();
    String id = await ShardpModel().getSenderId();
    final m = MessageModel(
      senderId: id,
      roomId: '674a0b28628dfde5ad21f103',
      file: MediaFile.fromJson({
        'name': 'imageName.mp4',
        'type': 'video',
        'base64': videoBytes,
        'data': videoFile
      }),
    );
    socket.emit('uploadFiles', m.toJson());
    cubitMessageList.add(m);
    emit(ChatSuccess(messagesList: cubitMessageList));
  }

  sendSound({required Socket socket}) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return;
    File file = File(result.files.single.path!);
    List<int> audioBytes = await file.readAsBytes();
    String id = await ShardpModel().getSenderId();
    final m = MessageModel(
      senderId: id,
      roomId: '674a0b28628dfde5ad21f103',
      file: MediaFile.fromJson({
        'name': 'sound.mp3',
        'type': 'file',
        'base64': audioBytes,
        'sound': result.files.single.path,
      }),
    );
  //  socket.emit('uploadFiles', m.toJson());
    cubitMessageList.add(m);
    emit(ChatSuccess(messagesList: cubitMessageList));
  }
}
