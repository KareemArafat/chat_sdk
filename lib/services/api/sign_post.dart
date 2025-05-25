import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/services/api/api.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';

class LoginPost {
  Future<Map<String, dynamic>> loginPostFn({
    required String userId,
    required String appToken,
    required String apiKey,
  }) async {
    final responseData = await Api().post(
      url: "$baseUrl/auth/login",
      header: apiKey,
      body: {
        'userId': userId,
        'appToken': appToken,
      },
    );
    final userName = responseData['data']['user']['userName'];
    final senderId = responseData['data']['user']['_id'];
    final token = responseData['data']['token'];

    await ShardpModel().setUserName(userName);
    await ShardpModel().setSenderId(senderId);
    await ShardpModel().setToken(token);
    await ShardpModel().setUserId(userId);
    await ShardpModel().setApiKey(apiKey);
    return responseData;
  }
}

class RegisterPost {
  Future<Map<String, dynamic>> signPostFn({
    required String userName,
    required String userId,
    required String appToken,
    required String apiKey,
  }) async {
    return await Api().post(
      url: "$baseUrl/auth/register",
      header: apiKey,
      body: {
        'userName': userName,
        'userId': userId,
        'appToken': appToken,
      },
    );
  }
}
