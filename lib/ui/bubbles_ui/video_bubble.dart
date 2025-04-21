import 'dart:developer';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/services/api/get_file.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoBubbleL extends StatelessWidget {
  final MessageModel o;

  const VideoBubbleL({super.key, required this.o});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: baseColor1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VideoView(o: o),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    o.fileTime!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoView extends StatefulWidget {
  final MessageModel o;

  const VideoView({super.key, required this.o});

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
      final tempFile = File('${tempDir.path}/temp_video.mp4');
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
                              widget.o.file!.dataSend = await LoadFiles()
                                  .getFileFn(
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

class VideoBubbleR extends StatelessWidget {
  final MessageModel o;

  const VideoBubbleR({super.key, required this.o});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            color: baseAppBarColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              VideoView(o: o),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    o.fileTime!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
