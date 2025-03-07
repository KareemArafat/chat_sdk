import 'package:chat_sdk/models/message_model.dart';

abstract class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatSuccess extends ChatState {
   List<MessageModel> messagesList = [];
  ChatSuccess({required this.messagesList});
}