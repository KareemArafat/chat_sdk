import 'package:chat_sdk/cubits/auth_cubit/auth_states.dart';
import 'package:chat_sdk/SDK/core/api/sign_post.dart';
import 'package:chat_sdk/core/shardP/shard_p_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());

  void signFn(
      {required String userName,
      required String userId,
      required String appToken,
      required String apiKey}) async {
    emit(LoginLoading());

    try {
      await Sign().loginFn(userId: userId, appToken: appToken, apiKey: apiKey);
      ShardpModel().setLoginValue(flag: true);
      String token = await ShardpModel().getToken();
      emit(LoginSuccess(apiKey: apiKey, token: token));
    } catch (e) {
      if (e.toString() ==
          'Exception: Error: 401, Response: {"status":"FAIL","message":"Invalid userId or appToken"}') {
        try {
          await Sign().registerFn(
            userName: userName,
            userId: userId,
            appToken: appToken,
            apiKey: apiKey,
          );
          await Sign()
              .loginFn(userId: userId, appToken: appToken, apiKey: apiKey);
          String token = await ShardpModel().getToken();
          emit(LoginSuccess(apiKey: apiKey, token: token));
        } catch (e) {
          emit(LoginFailure(errorMessage: e.toString()));
        }
      }
    }
  }

  void check() async {
    bool loginValue = await ShardpModel().getLoginValue();
    if (loginValue) {
      String token = await ShardpModel().getToken();
      String apiKey = await ShardpModel().getApiKey();
      emit(CheckSuccess(token: token, apiKey: apiKey));
    } else {
      emit(CheckFailure());
    }
  }
}
