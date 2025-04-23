import 'package:chat_sdk/cubits/auth_cubit/auth_states.dart';
import 'package:chat_sdk/services/api/login_post.dart';
import 'package:chat_sdk/services/api/sign_post.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());

  void loginFn({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await LoginPost().loginPostFn(email: email, password: password);
      String token = await ShardpModel().getToken();
      ShardpModel().setLoginValue(flag: true);
      emit(LoginSuccess(token: token));
    } catch (e) {
      emit(LoginFailure(errorMessage: e.toString()));
    }
  }

  void signFn(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    emit(SignLoading());
    try {
      await SignPost().signPostFn(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password);
      emit(SignSuccess());
    } catch (e) {
      emit(SignFailure(errorMessage: e.toString()));
    }
  }

  void check() async {
    bool loginValue = await ShardpModel().getLoginValue();
    emit(CheckInitial());
    if (loginValue) {
      String token = await ShardpModel().getToken();

      emit(CheckSuccess(token: token));
    } else {
      emit(CheckFailure(errorMess: 'shard error .. login value is false'));
    }
  }
}
