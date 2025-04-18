import 'dart:developer';

import 'package:chat_sdk/cubits/lists_cubit/lists_state.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/models/room_model.dart';
import 'package:chat_sdk/services/api/get_rooms.dart';
import 'package:chat_sdk/services/socket/socket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListsCubit extends Cubit<ListsState> {
  ListsCubit() : super(ListsInitial());
  List<RoomModel> rooms = [];
  getHomeList() async {
    emit(ListsLoading());
    try {
      rooms = (await GetRooms().getRoomsFn()) ?? [];
      emit(ListsSuccess(rooms: rooms));
    } catch (e) {
      log(e.toString());
    }
  }

  getMessList() async {
    emit(ListsLoading());
    try {
      List<MessageModel> messages = [];
      emit(ListsSuccess(messages: messages));
    } catch (e) {
      log(e.toString());
    }
  }

  addRoom({required SocketService socketService, required String user}) async {
    emit(ListsLoading());
    try {
      socketService.createRoom(members: [user]);
      emit(RoomSuccess(room: rooms));
    } catch (e) {
      log(e.toString());
    }
  }
}
