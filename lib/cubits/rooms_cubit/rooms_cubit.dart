import 'package:chat_sdk/cubits/rooms_cubit/room_state.dart';
import 'package:chat_sdk/models/room_model.dart';
import 'package:chat_sdk/services/rooms_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(ListsInitial());

  void getRoomsList() async {
    emit(ListsLoading());
    try {
      List<RoomModel>? rooms = (await RoomsService().getRooms())!;
      emit(ListsSuccess(rooms: rooms));
    } catch (e) {
      emit(ListsFailure());
    }
  }

  void addRoom(
      {required String type, required List<String> user, String? name}) async {
    emit(ListsLoading());
    try {
      bool flag = await RoomsService()
          .createRoom(members: user, roomName: name, type: type);
      if (flag) {
        List<RoomModel> rooms = (await RoomsService().getRooms())!;
        emit(CreateSuccess(rooms: rooms));
      } else {
        emit(CreateFailure());
      }
    } catch (e) {
      emit(ListsFailure());
    }
  }
}
