import 'dart:developer';
import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/SDK/models/message_model.dart';
import 'package:chat_sdk/SDK/services/message_service.dart';
import 'package:chat_sdk/core/shardP/shard_p_model.dart';
import 'package:chat_sdk/ui/bubbles_ui/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoBubble extends StatelessWidget {
  const VideoBubble({super.key, required this.o, required this.isMe});
  final MessageModel o;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.bottomLeft : Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomRight: isMe ? const Radius.circular(30) : Radius.zero,
              bottomLeft: isMe ? Radius.zero : const Radius.circular(30),
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
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.o.file!.path == null) {
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
                              widget.o.file!.path = null;
                              await _initializeVideo();
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
