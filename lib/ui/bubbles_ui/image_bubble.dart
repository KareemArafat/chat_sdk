import 'dart:developer';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/services/api/get_file.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';
import 'package:chat_sdk/ui/bubbles_ui/time_widget.dart';
import 'package:flutter/material.dart';

class ImageBubble extends StatelessWidget {
  const ImageBubble({super.key, required this.o, required this.isMe});
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
              ImageView(o: o),
              const SizedBox(height: 4),
              TimeWidget(time: o.fileTime),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: widget.o.file!.path == null
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
                            widget.o.file!.dataSend = await LoadFiles()
                                .getFileFn(
                                    path: widget.o.file!.path!, token: token);
                            widget.o.file!.path = null;
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
