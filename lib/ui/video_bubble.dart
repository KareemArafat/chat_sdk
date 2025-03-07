import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoBubble extends StatefulWidget {
  final MessageModel o;
  const VideoBubble({super.key, required this.o});

  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble> {
  VideoPlayerController? controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  void loadVideo() async {
    controller = VideoPlayerController.file(File(widget.o.file!.data!.path))
      ..initialize().then((_) {
        setState(() {});
      });
    controller!.addListener(() {
      setState(() {
        isPlaying = controller!.value.isPlaying;
      });
      if (controller!.value.position >= controller!.value.duration) {
        setState(() {
          isPlaying = false;
        });
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
          height: MediaQuery.of(context).size.height / 3.2,
          width: MediaQuery.of(context).size.width / 2,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            color: baseColor1,
          ),
          child: controller != null && controller!.value.isInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: controller!.value.size.width,
                            height: controller!.value.size.height,
                            child: VideoPlayer(controller!),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isPlaying ? controller!.pause() : controller!.play();
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
                  child: CircularProgressIndicator(
                  color: Colors.white,
                )),
        ),
      ),
    );
  }
}
