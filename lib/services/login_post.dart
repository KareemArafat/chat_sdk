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
    final senderId = responseData['data']['user']['_id'];
    final token = responseData['data']['token'];
    // List<String> roomId = responseData['data']['user']['rooms'];
    await ShardpModel().setFirstName(firstName);
    await ShardpModel().setLastName(lastName);
    await ShardpModel().setSenderId(senderId);
    await ShardpModel().setToken(token);

    return responseData;
  }
}
