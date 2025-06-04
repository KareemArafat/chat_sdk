import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/services/rooms_service.dart';
import 'package:chat_sdk/ui/bubbles_ui/file_bubble.dart';
import 'package:chat_sdk/ui/bubbles_ui/sound_bubble.dart';
import 'package:chat_sdk/ui/custom_ui/chat_bottom_field.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/ui/bubbles_ui/text_bubble.dart';
import 'package:chat_sdk/ui/bubbles_ui/image_bubble.dart';
import 'package:chat_sdk/ui/bubbles_ui/video_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    super.key,
    this.id,
    required this.name,
    required this.roomId,
  });
  final String? id;
  final String name;
  final String roomId;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<MessageModel> messageList = [];

  @override
  Widget build(BuildContext context) {
    bool isWriting = false;
    bool isOnline = false;
    bool isTyping = false;
    bool isRecording = false;
    return Stack(
      children: [
        Positioned.fill(
            child:
                Image.asset("assets/images/chat_image.jpg", fit: BoxFit.cover)),
        Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              toolbarHeight: MediaQuery.of(context).size.height / 13,
              backgroundColor: baseAppBarColor,
              leadingWidth: MediaQuery.of(context).size.width * 0.1,
              title: Row(
                children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 6, right: 15),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage('assets/images/user_image.jpg'),
                      )),
                  BlocConsumer<ChatCubit, ChatState>(
                    listener: (context, state) {
                      if (state is Typing && state.userId != id) {
                        isTyping = state.typing;
                      }
                      if (state is Online && state.userId != id) {
                        isOnline = state.online;
                      }
                      if (state is Recording && state.userId != id) {
                        isRecording = state.recording;
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.058)),
                          isTyping
                              ? Text('Typing ..',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 11, 255, 52),
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      fontWeight: FontWeight.w500))
                              : isOnline
                                  ? Text('Online',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 11, 255, 52),
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.035,
                                          fontWeight: FontWeight.w500))
                                  : isRecording
                                      ? Text('Recoding audio ..',
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 11, 255, 52),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                              fontWeight: FontWeight.w500))
                                      : const SizedBox.shrink(),
                        ],
                      );
                    },
                  )
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, color: Colors.white)),
              ],
            ),
            body: Column(
              children: [
                BlocConsumer<ChatCubit, ChatState>(
                  listener: (context, state) {
                    if (state is ChatSuccess) {
                      messageList.add(state.mess);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 40),
                            curve: Curves.easeIn);
                      });
                    }
                  },
                  builder: (context, state) {
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        controller: scrollController,
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          MessageModel message = messageList[index];
                          if (message.senderId == id &&
                              message.file?.dataSend == null) {
                            return TextBubble(o: message, isMe: true);
                          } else if (message.senderId != id &&
                              message.file?.path == null) {
                            return TextBubble(o: message, isMe: false);
                          } else if (message.senderId == id &&
                              message.file!.type == 'image') {
                            return ImageBubble(o: message, isMe: true);
                          } else if (message.senderId != id &&
                              message.file!.type == 'image') {
                            return ImageBubble(o: message, isMe: false);
                          } else if (message.senderId == id &&
                              message.file!.type == 'video') {
                            return VideoBubble(o: message, isMe: true);
                          } else if (message.senderId != id &&
                              message.file!.type == 'video') {
                            return VideoBubble(o: message, isMe: false);
                          } else if (message.senderId == id &&
                              message.file!.type == 'file') {
                            return FileBubble(o: message, isMe: true);
                          } else if (message.senderId != id &&
                              message.file!.type == 'file') {
                            return FileBubble(o: message, isMe: false);
                          } else if (message.senderId == id &&
                              message.file!.type == 'sound') {
                            return SoundBubble(
                                o: message, isMe: true, isVoice: false);
                          } else if (message.senderId != id &&
                              message.file!.type == 'sound') {
                            return SoundBubble(
                                o: message, isMe: false, isVoice: false);
                          } else if (message.senderId == id &&
                              message.file!.type == 'record') {
                            return SoundBubble(
                                o: message, isMe: true, isVoice: true);
                          } else if (message.senderId != id &&
                              message.file!.type == 'record') {
                            return SoundBubble(
                                o: message, isMe: false, isVoice: true);
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
                    roomId: roomId,
                    soundFn: () {
                      Navigator.pop(context);
                      BlocProvider.of<ChatCubit>(context)
                          .sendSound(roomId: roomId);
                    },
                    fileFn: () {
                      Navigator.pop(context);
                      BlocProvider.of<ChatCubit>(context)
                          .sendFile(roomId: roomId);
                    },
                    videoRecordFn: () {
                      Navigator.pop(context);
                      BlocProvider.of<ChatCubit>(context).sendVideo(
                          source: ImageSource.camera, roomId: roomId);
                    },
                    videoFn: () {
                      Navigator.pop(context);
                      BlocProvider.of<ChatCubit>(context).sendVideo(
                          source: ImageSource.gallery, roomId: roomId);
                    },
                    imageFn: () {
                      Navigator.pop(context);
                      BlocProvider.of<ChatCubit>(context).sendImage(
                          source: ImageSource.gallery, roomId: roomId);
                    },
                    cameraFn: () {
                      Navigator.pop(context);

                      BlocProvider.of<ChatCubit>(context).sendImage(
                          source: ImageSource.camera, roomId: roomId);
                    },
                    controller: textController,
                    submitted: (p0) {
                      BlocProvider.of<ChatCubit>(context)
                          .sendMess(mess: p0, roomId: roomId);
                      RoomsService().typingCheck(roomId, false);
                      textController.clear();
                    },
                    changed: (p0) {
                      if (p0.isNotEmpty && !isWriting) {
                        RoomsService().typingCheck(roomId, true);
                        isWriting = true;
                      } else if (p0.isEmpty) {
                        RoomsService().typingCheck(roomId, false);
                        isWriting = false;
                      }
                    },
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
