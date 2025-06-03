import 'package:chat_sdk/core/api/sign_post.dart';

class AuthService {
  void initialize({
    required String userName,
    required String userId,
    required String appToken,
    required String apiKey,
  }) async {
    try {
      await Sign().loginFn(userId: userId, appToken: appToken, apiKey: apiKey);
    } catch (e) {
      if (e.toString() ==
          'Exception: Error: 401, Response: {"status":"FAIL","message":"Invalid userId or appToken"}') {
        await Sign().registerFn(
          userName: userName,
          userId: userId,
          appToken: appToken,
          apiKey: apiKey,
        );
        await Sign()
            .loginFn(userId: userId, appToken: appToken, apiKey: apiKey);
      }
    }
  }
}
