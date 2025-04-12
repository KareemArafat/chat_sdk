import 'package:chat_sdk/models/room_model.dart';

abstract class ListsState {}

class ListsInitial extends ListsState{}

class ListsLoading extends ListsState {}

class ListsSuccess extends ListsState {
  List<RoomModel> rooms;
  ListsSuccess({required this.rooms});
}

class ListsFailure extends ListsState {
  String errorMessage;
  ListsFailure({required this.errorMessage});
}
