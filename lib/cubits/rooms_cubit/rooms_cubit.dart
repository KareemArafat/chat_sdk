import 'package:chat_sdk/cubits/rooms_cubit/room_state.dart';
import 'package:chat_sdk/models/room_model.dart';
import 'package:chat_sdk/services/api/get_rooms.dart';
import 'package:chat_sdk/services/socket/socket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(ListsInitial());

  void getRoomsList() async {
    emit(ListsLoading());
    try {
      List<RoomModel>? rooms = (await GetRooms().getRoomsFn())!;
      emit(ListsSuccess(rooms: rooms));
    } catch (e) {
      emit(ListsFailure());
    }
  }

  void addRoom(
      {required SocketService socketService,
      required String type,
      required List<String> user,
      String? name}) async {
    emit(ListsLoading());
    try {
      bool flag =
          await socketService.createRoom(members: user, roomName: name,type: type);
      if (flag) {
        List<RoomModel> rooms = (await GetRooms().getRoomsFn())!;
        emit(CreateSuccess(rooms: rooms));
      } else {
        emit(CreateFailure());
      }
    } catch (e) {
      emit(ListsFailure());
    }
  }
}
