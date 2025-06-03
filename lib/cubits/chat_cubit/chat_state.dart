import 'package:chat_sdk/models/message_model.dart';

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

final class AiMessageSent extends ChatState {
  final String mess;
  AiMessageSent({required this.mess});
}

final class AiMessageReceived extends ChatState {
  final String mess;
  AiMessageReceived({required this.mess});
}

final class Typing extends ChatState {
  final String userId;
  final bool typing;
  Typing({required this.userId, required this.typing});
}

final class Online extends ChatState {
  final String userId;
  final bool online;
  Online({required this.userId, required this.online});
}
