import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/core/api/api.dart';
import 'package:chat_sdk/core/shardP/shard_p_model.dart';

class Sign {
  Future<Map<String, dynamic>> loginFn({
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

  Future<Map<String, dynamic>> registerFn({
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
