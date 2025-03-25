import 'dart:developer';
import 'package:chat_sdk/consts.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect(String token) {
    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token}
    });
    socket.connect();
    socket.onConnect((_) => log('server is connected ^_^'));
    socket.onDisconnect((_) => log('server is disconnected >_<'));
    socket.onError((error) => log('Socket error: $error'));
    socket.on('error', (error) => log('Socket error: $error'));
  }

  void dispose() {
    socket.disconnect();
    socket.dispose();
    log('Socket connection closed ✔✔');
  }

  void createRoom(List members, String? roomName) {
    socket.emit('createRoom', {
      'type': 'direct',
      'roomName': roomName,
      'members': members,
    });
  }

  void joinRoom(String roomId) {
    socket.emit('joinRoom', roomId);
  }
}
