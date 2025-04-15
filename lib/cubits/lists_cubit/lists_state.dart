import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/models/room_model.dart';

abstract class ListsState {}

class ListsInitial extends ListsState {}

class ListsLoading extends ListsState {}

class ListsSuccess extends ListsState {
  List<RoomModel>? rooms;
  List<MessageModel>? messages;
  ListsSuccess({this.rooms, this.messages});
}