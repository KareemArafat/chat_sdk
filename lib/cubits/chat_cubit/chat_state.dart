import 'package:chat_sdk/SDK/models/message_model.dart';

abstract class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatSuccess extends ChatState {
  final MessageModel mess;
  ChatSuccess({required this.mess});
}

final class ReactSuccess extends ChatState {
  final String react;
  final String messId;
  ReactSuccess({required this.react, required this.messId});
}
