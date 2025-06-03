import 'dart:developer';
import 'package:chat_sdk/core/consts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._internal();
  static final SocketService instance = SocketService._internal();

  late IO.Socket socket;

  void connectToServer(String token, String apiKey) {
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
    socket.onError((error) => log('Socket client side error: $error'));
  }

  void closeServerConnection() {
    socket.disconnect();
    socket.dispose();
  }
}
