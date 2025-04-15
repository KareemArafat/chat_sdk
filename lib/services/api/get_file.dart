import 'dart:developer';
import 'package:chat_sdk/consts.dart';
import 'package:http/http.dart' as http;

class GetFile {
  Future<dynamic> get({required String url, String? token}) async {
    Map<String, String> headers = {};

    if (token != null) {
      headers.addAll({'Authorization': 'Bearer $token'});
    }

    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.bodyBytes;
    } else {
      throw Exception(
          'there is a problem with status code ${response.statusCode}');
    }
  }

  Future<List<int>?> getFileFn(
      {required String path, required String token}) async {
    try {
      final dataList =
          await get(url: "$baseUrl/download?path=$path&&token=$token");
      return dataList;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
