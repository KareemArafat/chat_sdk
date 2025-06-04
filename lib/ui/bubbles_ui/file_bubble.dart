import 'dart:developer';
import 'dart:io';
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
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileBubble extends StatelessWidget {
  const FileBubble({super.key, required this.o, required this.isMe});
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
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isMe ? baseColor1 : baseAppBarColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomRight:
                            isMe ? const Radius.circular(15) : Radius.zero,
                        bottomLeft:
                            isMe ? Radius.zero : const Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        FileView(o: o),
                        const SizedBox(height: 4),
                        const TimeWidget(),
                      ],
                    )),
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
                      bottom: -24,
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

class FileView extends StatefulWidget {
  const FileView({super.key, required this.o});
  final MessageModel o;

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool initial = widget.o.file!.dataSend != null ? true : false;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Image.asset(
            'assets/images/file.jpg',
            height: 150,
            width: 140,
            fit: BoxFit.fill,
          ),
          initial
              ? GestureDetector(
                  onTap: () async {
                    final tempDir = await getTemporaryDirectory();
                    final file = File('${tempDir.path}/${widget.o.file!.name}');
                    await file
                        .writeAsBytes(widget.o.file!.dataSend! as List<int>);
                    await OpenFilex.open(file.path);
                  },
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('Open',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                )
              : isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 5, bottom: 6),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        strokeAlign: -5,
                        color: Colors.deepPurpleAccent,
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
                        }
                      },
                      icon: const Icon(
                        Icons.download_sharp,
                        size: 30,
                      ),
                    ),
        ],
      ),
    );
  }
}
