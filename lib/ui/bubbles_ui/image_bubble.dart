import 'dart:developer';
import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/services/message_service.dart';
import 'package:chat_sdk/core/shardP/shard_p_model.dart';
import 'package:chat_sdk/ui/bubbles_ui/react_box.dart';
import 'package:chat_sdk/ui/bubbles_ui/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageBubble extends StatelessWidget {
  const ImageBubble({super.key, required this.o, required this.isMe});
  final MessageModel o;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        showReactionBox(context, details.globalPosition, o.messageId!, isMe);
      },
      child: Align(
        alignment: isMe ? Alignment.bottomLeft : Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IntrinsicWidth(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: const Radius.circular(15),
                      bottomRight:
                          isMe ? const Radius.circular(15) : Radius.zero,
                      bottomLeft:
                          isMe ? Radius.zero : const Radius.circular(15),
                    ),
                    color: isMe ? baseColor1 : baseAppBarColor,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImageView(o: o),
                      const SizedBox(height: 4),
                      TimeWidget(time: o.fileTime),
                    ],
                  ),
                ),
              ),
              BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ReactSuccess) {
                    if (o.messageId == state.messId) {
                      o.reacts ??= [];
                      if (!o.reacts!.contains(state.react)) {
                        o.reacts!.add(state.react);
                      }
                    }
                  }
                },
                builder: (context, state) {
                  if (o.reacts != null) {
                    return Positioned(
                      bottom: -22,
                      left: isMe ? 10 : null,
                      right: isMe ? null : 10,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey[900],
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: o.reacts!
                              .map((react) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    child: Text(
                                      react,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageView extends StatefulWidget {
  const ImageView({super.key, required this.o});
  final MessageModel o;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool initial = widget.o.file!.dataSend != null ? true : false;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: initial // widget.o.file!.path == null
          ? Image.memory(
              widget.o.file!.dataSend!,
              fit: BoxFit.contain,
            )
          : Stack(
              alignment: Alignment.bottomRight,
              children: [
                Image.asset(
                  'assets/images/photo.jpg',
                  fit: BoxFit.contain,
                ),
                isLoading
                    ? const Padding(
                        padding: EdgeInsets.only(right: 5, bottom: 6),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          strokeAlign: -5,
                        ),
                      )
                    : IconButton(
                        onPressed: () async {
                          isLoading = true;
                          setState(() {});
                          try {
                            String token = await ShardpModel().getToken();
                            widget.o.file!.dataSend = await MessageService()
                                .downloadFiles(
                                    path: widget.o.file!.path!, token: token);
                            isLoading = false;
                            setState(() {});
                          } catch (e) {
                            log('error .. ${e.toString()}');
                            isLoading = false;
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.download_sharp,
                          size: 30,
                        ))
              ],
            ),
    );
  }
}
