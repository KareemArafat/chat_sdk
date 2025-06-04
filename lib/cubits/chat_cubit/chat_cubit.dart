import 'dart:developer';
import 'dart:io';
import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/services/message_service.dart';
import 'package:chat_sdk/services/rooms_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  void sendMess({required String mess, required String roomId}) async {
    final message =
        await MessageService().sendMessage(mess: mess, roomId: roomId);
    emit(ChatSuccess(mess: message));
  }

  void sendImage({required ImageSource source, required String roomId}) async {
    final result = await ImagePicker().pickImage(source: source);
    if (result == null) return;
    File imgFile = File(result.path);
    final imageBytes = imgFile.readAsBytesSync();
    final message = await MessageService().sendFiles(
        roomId: roomId,
        bytesFile: imageBytes,
        name: result.name,
        type: 'image');
    emit(ChatSuccess(mess: message));
  }

  void sendVideo({required ImageSource source, required String roomId}) async {
    final result = await ImagePicker().pickVideo(source: source);
    if (result == null) return;
    File videoFile = File(result.path);
    final videoBytes = videoFile.readAsBytesSync();
    final message = await MessageService().sendFiles(
        roomId: roomId,
        bytesFile: videoBytes,
        name: result.name,
        type: 'video');
    emit(ChatSuccess(mess: message));
  }

  void sendSound({required String roomId}) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return;
    File file = File(result.files.single.path!);
    final audioBytes = await file.readAsBytes();
    final message = await MessageService().sendFiles(
        roomId: roomId,
        bytesFile: audioBytes,
        name: result.files.single.name,
        type: 'sound');
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
    final message = await MessageService().sendFiles(
        roomId: roomId,
        bytesFile: fileBytes,
        name: result.files.single.name,
        type: 'file');
    emit(ChatSuccess(mess: message));
  }

  void sendRecord({required String path, required String roomId}) async {
    File result = File(path);
    final recordBytes = await result.readAsBytes();
    final message = await MessageService().sendFiles(
        roomId: roomId, bytesFile: recordBytes, name: path, type: 'record');
    emit(ChatSuccess(mess: message));
  }

  void receiveMess() {
    MessageService().receiveMessages(
      onMessageReceived: (message) {
        emit(ChatSuccess(mess: message));
      },
    );
  }

  void sendReact({required String react, required String messId}) {
    server.socket.emit('sendReact', {'messageId': messId, 'type': react});
    emit(ReactSuccess(react: react, messId: messId));
  }

  void receiveReact() {
    MessageService().receiveReact(
      onReactReceived: (messageId, react) {
        emit(ReactSuccess(react: react, messId: messageId));
      },
    );
  }

  void aiMessage({required String message}) async {
    emit(AiMessageSent(mess: message));
    try {
      String response = await MessageService().aiMessage(message: message);
      emit(AiMessageReceived(mess: response));
    } catch (e) {
      log(e.toString());
    }
  }

  void onTyping() {
    RoomsService().typingResult(
      typingFn: (userId, typing) {
        emit(Typing(userId: userId, typing: typing));
      },
    );
  }

  void onOnline() {
    RoomsService().onlineResult(
      onlineFn: (userId, online) {
        emit(Online(userId: userId, online: online));
      },
    );
  }

  void onRecord() {
    RoomsService().recordingResult(
      recordFn: (userId, recording) {
        emit(Recording(userId: userId, recording: recording));
      },
    );
  }
}
