import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/services/api_post.dart';
import 'package:chat_sdk/shardP/shard_p_model.dart';

class LoginPost {
  Future<Map<String, dynamic>> loginPostFn({
    required String email,
    required String password,
  }) async {
    final responseData = await Api().post(
      url: "$baseUrl/auth/login",
      body: {
        'username': email,
        'password': password,
      },
    );

    final firstName = responseData['data']['user']['firstname'];
    final lastName = responseData['data']['user']['lastname'];
    final id = responseData['data']['user']['_id'];
    final token = responseData['data']['token'];
    final userName = responseData['data']['user']['username'];

    await ShardpModel().setFirstName(firstName);
    await ShardpModel().setLastName(lastName);
    await ShardpModel().setSenderId(id);
    await ShardpModel().setToken(token);
    await ShardpModel().setUserName(userName);

    return responseData;
  }
}
