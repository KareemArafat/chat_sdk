import 'dart:developer';
import 'package:chat_sdk/consts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._internal();
  static final SocketService instance = SocketService._internal();

  late IO.Socket socket;

  void connect(String token, String apiKey) async {
    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token, 'key': apiKey},
    });
    socket.connect();
    socket.off('connect');
    socket.off('disconnect');
    socket.onConnect((data) => log('server is connected ^_^'));
    socket.onDisconnect((data) => log('server is disconnected >_<'));
    socket.onError((error) => log('Socket error client side: $error'));
  }

  void dispose() {
    socket.disconnect();
    socket.dispose();
    log('Socket connection closed ✔✔');
  }
}
