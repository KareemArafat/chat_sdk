import 'package:chat_sdk/consts.dart';
import 'package:flutter/material.dart';

attachmentSheet(
  BuildContext context, {
  void Function()? cameraFn,
  void Function()? videoRecordFn,
  void Function()? imageFn,
  void Function()? videoFn,
  void Function()? filesFn,
  void Function()? soundFn,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.32,
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AttachmentsIcons(
                  pressed: cameraFn,
                  color: Colors.black12,
                  iconData: Icons.camera_alt,
                  text: 'Camera',
                ),
                AttachmentsIcons(
                  pressed: videoRecordFn,
                  color: Colors.black12,
                  iconData: Icons.videocam,
                  text: 'Video',
                ),
                AttachmentsIcons(
                  pressed: soundFn,
                  color: Colors.black12,
                  iconData: Icons.music_note,
                  text: 'Music',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AttachmentsIcons(
                  pressed: imageFn,
                  color: Colors.black12,
                  iconData: Icons.image,
                  text: 'Images',
                ),
                AttachmentsIcons(
                  pressed: videoFn,
                  color: Colors.black12,
                  iconData: Icons.video_collection,
                  text: 'Videos',
                ),
                AttachmentsIcons(
                  pressed: filesFn,
                  color: Colors.black12,
                  iconData: Icons.file_open,
                  text: 'Files',
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class AttachmentsIcons extends StatelessWidget {
  const AttachmentsIcons(
      {super.key,
      required this.iconData,
      required this.color,
      required this.text,
      this.pressed});
  final IconData iconData;
  final Color color;
  final String text;
  final void Function()? pressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: IconButton(
              onPressed: pressed,
              icon: Icon(iconData, color: baseColor1),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
