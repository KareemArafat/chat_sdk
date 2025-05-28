import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/ui/custom_ui/attachment_bottom_sheet.dart';
import 'package:chat_sdk/ui/custom_ui/recording_process.dart';
import 'package:chat_sdk/ui/bubbles_ui/recoding.dart';
import 'package:flutter/material.dart';

class ChatBottomField extends StatelessWidget {
  const ChatBottomField(
      {super.key,
      this.changed,
      this.submitted,
      this.controller,
      this.voiceFn,
      this.emojiFn,
      this.soundFn,
      this.cameraFn,
      this.imageFn,
      this.videoFn,
      this.fileFn,
      this.videoRecordFn,
      this.recordObj,
      this.roomId,
      this.aiChat = false});
  final Function(String)? changed;
  final Function(String)? submitted;
  final TextEditingController? controller;
  final void Function()? emojiFn;
  final void Function()? soundFn;
  final void Function()? voiceFn;
  final void Function()? cameraFn;
  final void Function()? imageFn;
  final void Function()? videoFn;
  final void Function()? fileFn;
  final void Function()? videoRecordFn;
  final RecordService? recordObj;
  final String? roomId;
  final bool aiChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  onChanged: changed,
                  controller: controller,
                  onSubmitted: submitted,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Type message...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 56, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: baseColor1, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: baseColor1, width: 2),
                    ),
                  ),
                ),
                Positioned(
                  left: 6,
                  child: IconButton(
                    onPressed: emojiFn,
                    icon: const Icon(Icons.emoji_emotions, color: baseColor1),
                  ),
                ),
                if (aiChat == false)
                  Positioned(
                    right: 8,
                    child: IconButton(
                      onPressed: () {
                        attachmentSheet(
                          context,
                          cameraFn: cameraFn,
                          filesFn: fileFn,
                          imageFn: imageFn,
                          videoFn: videoFn,
                          soundFn: soundFn,
                          videoRecordFn: videoRecordFn,
                        );
                      },
                      icon: const Icon(Icons.attach_file, color: baseColor1),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          aiChat
              ? Container(
                  padding: const EdgeInsets.only(left: 3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                        BorderSide(color: baseColor1, width: 2)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_sharp, color: baseColor1),
                    onPressed: () {},
                  ),
                )
              : VoiceRecorderScreen(
                  recordObj: recordObj!,
                  roomId: roomId!,
                ),
        ],
      ),
    );
  }
}
