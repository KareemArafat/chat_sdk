import 'dart:io';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';
import 'package:chat_sdk/services/socket/message_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  void sendMess({required String mess, required String roomId}) async {
    String id = await ShardpModel().getSenderId();
    final message = await MessageService()
        .sendMessage(mess: mess, roomId: roomId, senderId: id);
    emit(ChatSuccess(mess: message));
  }

  void sendImage({required ImageSource source, required String roomId}) async {
    final result = await ImagePicker().pickImage(source: source);
    if (result == null) return;
    File imgFile = File(result.path);
    final imageBytes = imgFile.readAsBytesSync();
    String id = await ShardpModel().getSenderId();
    final message = await MessageService().sendFiles(
        roomId: roomId,
        bytesFile: imageBytes,
        name: result.name,
        type: 'image',
        senderId: id);
    emit(ChatSuccess(mess: message));
  }

  void sendVideo({required ImageSource source, required String roomId}) async {
    final result = await ImagePicker().pickVideo(source: source);
    if (result == null) return;
    File videoFile = File(result.path);
    final videoBytes = videoFile.readAsBytesSync();
    String id = await ShardpModel().getSenderId();
    final message = await MessageService().sendFiles(
        roomId: roomId,
        bytesFile: videoBytes,
        name: result.name,
        type: 'video',
        senderId: id);
    emit(ChatSuccess(mess: message));
  }

  void sendSound({required String roomId}) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return;
    File file = File(result.files.single.path!);
    final audioBytes = await file.readAsBytes();
    String id = await ShardpModel().getSenderId();
    final message = await MessageService().sendFiles(
        roomId: roomId,
        bytesFile: audioBytes,
        name: result.files.single.name,
        type: 'sound',
        senderId: id);
    emit(ChatSuccess(mess: message));
  }

  void sendFile({required String roomId}) async {
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
    final message = await MessageService().sendFiles(
        roomId: roomId,
        bytesFile: fileBytes,
        name: result.files.single.name,
        type: 'file',
        senderId: id);
    emit(ChatSuccess(mess: message));
  }

  void sendRecord({required String path, required String roomId}) async {
    File result = File(path);
    final recordBytes = await result.readAsBytes();
    String id = await ShardpModel().getSenderId();
    final message = await MessageService().sendFiles(
        roomId: roomId,
        bytesFile: recordBytes,
        name: path,
        type: 'record',
        senderId: id);
    emit(ChatSuccess(mess: message));
  }

  void receiveMess() async {
    String id = await ShardpModel().getSenderId();
    // server.socket.on('message', (data) {
    //   if (id != data['senderId']) {
    //     emit(ChatSuccess(mess: MessageModel.fromJson(data)));
    //   }
    // });
    final message = MessageService().receiveMessages(senderId: id);
    if (message != null) {
      emit(ChatSuccess(mess: message));
    }
  }

  void sendReact({required Socket socket}) {}

  void recvReact({required Socket socket}) {}
}
