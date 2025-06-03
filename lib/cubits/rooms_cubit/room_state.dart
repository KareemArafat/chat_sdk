import 'package:chat_sdk/models/room_model.dart';

abstract class RoomsState {}

class ListsInitial extends RoomsState {}
class ListsLoading extends RoomsState {}
class ListsFailure extends RoomsState {}
class ListsSuccess extends RoomsState {
  List<RoomModel>? rooms;
  ListsSuccess({this.rooms});
}

class CreateFailure extends RoomsState {}
class CreateSuccess extends RoomsState {
  List<RoomModel>? rooms;
  CreateSuccess({this.rooms});
}
