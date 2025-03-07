import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/services/api_post.dart';

class SignPost {
  Future<Map<String, dynamic>> signPostFn({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    return await Api().post(
      url: "$baseUrl/auth/register",
      body: {
        'username': email,
        'firstname': firstName,
        'lastname': lastName,
        'password': password,
      },
    );
  }
}
