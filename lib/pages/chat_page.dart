import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/custom_ui/chat_app_bar.dart';
import 'package:chat_sdk/custom_ui/chat_bottom_field.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/services/socket.dart';
import 'package:chat_sdk/ui/chat_bubble.dart';
import 'package:chat_sdk/ui/image_bubble.dart';
import 'package:chat_sdk/ui/video_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.token, this.id});
  final String token;
  final String? id;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SocketService socketService = SocketService();
  final TextEditingController textController = TextEditingController();
  VideoPlayerController? videoController;
  final ScrollController scrollController = ScrollController();
  List<MessageModel> messageList = [];

  @override
  void initState() {
    socketService.connect(widget.token);
    super.initState();
  }

  @override
  void dispose() {
    socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: Image.asset("assets/images/chat_image.jpg", fit: BoxFit.cover),
      ),
      Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            toolbarHeight: 65,
            backgroundColor: baseAppBarColor,
            title: const ChatAppBar()),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatSuccess) {
                    messageList = state.messagesList;
                  }
                },
                builder: (context, state) {
                  return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    controller: scrollController,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      if (messageList[index].senderId == widget.id &&
                          messageList[index].text != null) {
                        return ChatBubbleL(o: messageList[index]);
                      } else if (messageList[index].senderId != widget.id &&
                          messageList[index].text != null) {
                        return ChatBubbleR(o: messageList[index]);
                      } else if (messageList[index].senderId == widget.id &&
                          messageList[index].file!.type == 'image') {
                        return ImageBubbleL(o: messageList[index]);
                      } else if (messageList[index].senderId != widget.id &&
                          messageList[index].file!.type == 'image') {
                        return ImageBubbleL(o: messageList[index]);
                      } else if (messageList[index].senderId == widget.id &&
                          messageList[index].file!.type == 'video') {
                        return VideoBubble(o: messageList[index]);
                      } else if (messageList[index].senderId != widget.id &&
                          messageList[index].file!.type == 'video') {
                        return VideoBubble(o: messageList[index]);
                      } else {
                        return null;
                      }
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: ChatBottomField(
                soundFn: ()  {
                  //  Navigator.pop(context);
                  // BlocProvider.of<ChatCubit>(context).sendAudio();
                },
                videoFn: () {
                  Navigator.pop(context);
                  BlocProvider.of<ChatCubit>(context).sendVideo(
                      source: ImageSource.gallery,
                      socket: socketService.socket);
                },
                imageFn: () {
                  Navigator.pop(context);
                  BlocProvider.of<ChatCubit>(context).sendImage(
                      source: ImageSource.gallery,
                      socket: socketService.socket);
                },
                cameraFn: () {
                  Navigator.pop(context);
                  BlocProvider.of<ChatCubit>(context).sendImage(
                      source: ImageSource.camera, socket: socketService.socket);
                },
                controller: textController,
                submitted: (p0) {
                  BlocProvider.of<ChatCubit>(context)
                      .sendMess(socket: socketService.socket, mess: p0);
                  textController.clear();
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
