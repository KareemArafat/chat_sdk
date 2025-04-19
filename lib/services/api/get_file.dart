import 'dart:developer';
import 'dart:typed_data';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/services/api/api.dart';

class LoadFiles {
  Future<Uint8List?> getFileFn(
      {required String path, required String token}) async {
    try {
      final dataList = await Api()
          .getFile(url: "$baseUrl/download?path=$path&&token=$token");
      return dataList;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
