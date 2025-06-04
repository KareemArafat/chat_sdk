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
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoBubble extends StatelessWidget {
  const VideoBubble({super.key, required this.o, required this.isMe});
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
                      VideoView(o: o),
                      const SizedBox(height: 4),
                      const TimeWidget(),
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

class VideoView extends StatefulWidget {
  const VideoView({super.key, required this.o});
  final MessageModel o;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? controller;
  bool isPlaying = false;
  bool isLoading = false;
  bool isLocal = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo(pathCheck());
  }

  bool pathCheck() {
    if (widget.o.file!.path != null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _initializeVideo(bool x) async {
    if (x) {
      isLocal = true;
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${widget.o.file!.name}');
      await tempFile.writeAsBytes(widget.o.file!.dataSend! as List<int>);
      controller = VideoPlayerController.file(tempFile)
        ..initialize().then((_) => setState(() {}));
      _setupListener();
    } else {
      isLocal = false;
    }
  }

  void _setupListener() {
    controller?.addListener(() {
      if (mounted) {
        setState(() {
          isPlaying = controller!.value.isPlaying;
        });
        if (controller!.value.position >= controller!.value.duration) {
          setState(() => isPlaying = false);
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 200,
        child: isLocal
            ? controller != null && controller!.value.isInitialized
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: controller!.value.size.width,
                            height: controller!.value.size.height,
                            child: VideoPlayer(controller!),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isPlaying
                                ? controller!.pause()
                                : controller!.play();
                          });
                        },
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white))
            : Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: Icon(Icons.videocam, size: 50),
                    ),
                  ),
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.only(right: 5, bottom: 6),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.download_sharp, size: 24),
                          onPressed: () async {
                            setState(() => isLoading = true);
                            try {
                              final token = await ShardpModel().getToken();
                              widget.o.file!.dataSend = await MessageService()
                                  .downloadFiles(
                                      path: widget.o.file!.path!, token: token);
                              await _initializeVideo(true);
                            } catch (e) {
                              log('Video download error: $e');
                            }

                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                ],
              ),
      ),
    );
  }
}
