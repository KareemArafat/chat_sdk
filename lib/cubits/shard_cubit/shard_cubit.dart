import 'package:chat_sdk/cubits/shard_cubit/shard_state.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShardCubit extends Cubit<ShardState> {
  ShardCubit() : super(CheckInitial());

  check() async {
    bool loginValue = await ShardpModel().getLoginValue();
    emit(CheckInitial());
    try {
      if (loginValue) {
        String token = await ShardpModel().getToken();
        emit(CheckSuccess(token: token));
      } else {
        emit(CheckFailure(errorMess: 'login value is false'));
      }
    } catch (e) {
      emit(CheckFailure(errorMess: e.toString()));
    }
  }
}
