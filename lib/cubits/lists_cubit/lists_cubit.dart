import 'dart:developer';

import 'package:chat_sdk/cubits/lists_cubit/lists_state.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/models/room_model.dart';
import 'package:chat_sdk/services/api/get_rooms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListsCubit extends Cubit<ListsState> {
  ListsCubit() : super(ListsInitial());

  getHomeList() async {
    emit(ListsLoading());
    try {
      List<RoomModel> rooms = (await GetRooms().getRoomsFn()) ?? [];
      emit(ListsSuccess(rooms: rooms));
    } catch (e) {
      log(e.toString());
    }
  }

  getMessList() async {
    emit(ListsLoading());
    try {
      List<MessageModel> messages=[];
      emit(ListsSuccess(messages: messages));
    } catch (e) {
      log(e.toString());
    }
  }
}
