import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/ui/bubbles_ui/record_bubble.dart';
import 'package:chat_sdk/ui/bubbles_ui/sound_bubble.dart';
import 'package:chat_sdk/ui/custom_ui/chat_app_bar.dart';
import 'package:chat_sdk/ui/custom_ui/chat_bottom_field.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/services/socket/recoding.dart';
import 'package:chat_sdk/services/socket/socket.dart';
import 'package:chat_sdk/ui/bubbles_ui/text_bubble.dart';
import 'package:chat_sdk/ui/bubbles_ui/file_bubble.dart';
import 'package:chat_sdk/ui/bubbles_ui/image_bubble.dart';
import 'package:chat_sdk/ui/bubbles_ui/video_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    this.id,
    required this.roomId,
    required this.socketService,
    required this.name,
  });
  final String? id;
  final String roomId;
  final String name;
  final SocketService socketService;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late RecordService recordService = RecordService();
  final TextEditingController textController = TextEditingController();
  VideoPlayerController? videoController;
  final ScrollController scrollController = ScrollController();
  List<MessageModel> messageList = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatCubit>(context)
        .receiveMess(socket: widget.socketService.socket);
  }

  @override
  void dispose() {
    widget.socketService.socket.off('message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
          child:
              Image.asset("assets/images/chat_image.jpg", fit: BoxFit.cover)),
      Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            toolbarHeight: 65,
            backgroundColor: baseAppBarColor,
            title: ChatAppBar(name: widget.name)),
        body: Column(
          children: [
            BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatSuccess) {
                  messageList.add(state.mess);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeIn);
                  });
                }
              },
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    controller: scrollController,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                     if (messageList[index].senderId == widget.id &&
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
                      } else if (messageList[index].senderId == widget.id &&
                          messageList[index].file!.type == 'file') {
                        return FileBubble(o: messageList[index]);
                      } else if (messageList[index].senderId != widget.id &&
                          messageList[index].file!.type == 'file') {
                        return FileBubble(o: messageList[index]);
                      } else if (messageList[index].senderId == widget.id &&
                          messageList[index].file!.type == 'sound') {
                        return SoundBubble(o: messageList[index]);
                      } else if (messageList[index].senderId != widget.id &&
                          messageList[index].file!.type == 'sound') {
                        return SoundBubble(o: messageList[index]);
                      } else if (messageList[index].senderId == widget.id &&
                          messageList[index].file!.type == 'record') {
                        return RecordBubble(o: messageList[index]);
                      } else if (messageList[index].senderId != widget.id &&
                          messageList[index].file!.type == 'record') {
                        return RecordBubble(o: messageList[index]);
                      }
                      return null;
                    },
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(2),
              child: ChatBottomField(
                //         emojiFn: () {    BlocProvider.of<ChatCubit>(context)
                // .receiveMess(socket: widget.socketService.socket);},
                recordObj: recordService,
                socketObj: widget.socketService.socket,
                roomId: widget.roomId,
                soundFn: () {
                  Navigator.pop(context);
                  BlocProvider.of<ChatCubit>(context).sendSound(
                      socket: widget.socketService.socket,
                      roomId: widget.roomId);
                },
                fileFn: () {
                  Navigator.pop(context);
                  BlocProvider.of<ChatCubit>(context).sendFile(
                      socket: widget.socketService.socket,
                      roomId: widget.roomId);
                },
                videoRecordFn: () {
                  Navigator.pop(context);
                  BlocProvider.of<ChatCubit>(context).sendVideo(
                      source: ImageSource.camera,
                      socket: widget.socketService.socket,
                      roomId: widget.roomId);
                },
                videoFn: () {
                  Navigator.pop(context);
                  BlocProvider.of<ChatCubit>(context).sendVideo(
                      source: ImageSource.gallery,
                      socket: widget.socketService.socket,
                      roomId: widget.roomId);
                },
                imageFn: () {
                  Navigator.pop(context);
                  BlocProvider.of<ChatCubit>(context).sendImage(
                      source: ImageSource.gallery,
                      socket: widget.socketService.socket,
                      roomId: widget.roomId);
                },
                cameraFn: () {
                  Navigator.pop(context);

                  BlocProvider.of<ChatCubit>(context).sendImage(
                      source: ImageSource.camera,
                      socket: widget.socketService.socket,
                      roomId: widget.roomId);
                },
                controller: textController,
                submitted: (p0) {
                  BlocProvider.of<ChatCubit>(context).sendMess(
                      socket: widget.socketService.socket,
                      mess: p0,
                      roomId: widget.roomId);
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
