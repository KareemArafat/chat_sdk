import 'package:chat_sdk/models/mess_react.dart';
import 'package:chat_sdk/models/message_model.dart';

abstract class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatSuccess extends ChatState {
  final MessageModel mess;
  ChatSuccess({required this.mess});
}

final class ReactSuccess extends ChatState {
  final MessageReact react;
  ReactSuccess({required this.react});
}
