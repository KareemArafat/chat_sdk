import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/SDK/models/message_model.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/ui/bubbles_ui/text_bubble.dart';
import 'package:chat_sdk/ui/custom_ui/chat_bottom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController textController = TextEditingController();
  List<MessageModel> messageList = [];
  List<bool> isMeList = [];

  @override
  Widget build(BuildContext context) {
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
            title: Row(
              children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 6, right: 15),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/ai_icon.jpg'),
                    )),
                Text('Ai Chat',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.055))
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
                  if (state is AiMessageSent) {
                    MessageModel messageModel = MessageModel();
                    messageModel.text = state.mess;
                    messageList.add(messageModel);
                    isMeList.add(true);
                  }
                  if (state is AiMessageReceived) {
                    MessageModel messageModel = MessageModel();
                    messageModel.text = state.mess;
                    messageList.add(messageModel);
                    isMeList.add(false);
                  }
                },
                builder: (context, state) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        return TextBubble(
                          o: messageList[index],
                          isMe: isMeList[index],
                        );
                      },
                    ),
                  );
                },
              ),
              ChatBottomField(
                controller: textController,
                submitted: (p0) {
                  BlocProvider.of<ChatCubit>(context).aiMessage(message: p0);
                  textController.clear();
                },
                aiChat: true,
              )
            ],
          ),
        ),
      ],
    );
  }
}
