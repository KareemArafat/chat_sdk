import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/services/socket/socket_service.dart';

class MessageService {
  SocketService socketService = SocketService();

  MessageService({required this.socketService});

  MessageModel sendMessage(
      {required String mess,
      required String roomId,
      required String senderId}) {
    MessageModel message =
        MessageModel(senderId: senderId, roomId: roomId, text: mess);
    socketService.socket.emitWithAck('sendMessage', message.toJson(),
        ack: (data) {
      message.messageId = data['messageId'];
    });
    return message;
  }


  void sendFils() {}
}
