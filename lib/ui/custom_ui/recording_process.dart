import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_sdk/ui/custom_ui/recoding_control.dart';
import 'package:chat_sdk/services/socket/recoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';

// ignore: must_be_immutable
class VoiceRecorderScreen extends StatefulWidget {
  VoiceRecorderScreen(
      {super.key, required this.recordObj, required this.socketObj,required this.roomId});

  RecordService recordObj;
  Socket socketObj;
  String roomId;

  @override
  // ignore: library_private_types_in_public_api
  _VoiceRecorderScreenState createState() => _VoiceRecorderScreenState();
}

class _VoiceRecorderScreenState extends State<VoiceRecorderScreen> {
  Duration _recordingDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    widget.recordObj = RecordService(
      onDurationUpdate: (duration) {
        setState(() {
          _recordingDuration = duration;
        });
      },
    );
  }

  @override
  void dispose() {
    widget.recordObj.dispose();
    super.dispose();
  }

  void _startRecording() async {
    await widget.recordObj.startRecording();
    setState(() {});
  }

  Future<void> _stopRecording() async {
    await widget.recordObj.stopRecording();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.recordObj.isRecording
        ? RecordingControls(
            duration: _recordingDuration,
            onStop: () async {
              await _stopRecording();
              // ignore: use_build_context_synchronously
              BlocProvider.of<ChatCubit>(context).sendRecord(
                  socket: widget.socketObj, path: widget.recordObj.audioPath!,roomId: widget.roomId);
            },
            onCancel: () async {
              await _stopRecording();
              setState(() {});
            },
          )
        : Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                  BorderSide(color: baseColor1, width: 2)),
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, color: baseColor1),
              onPressed: _startRecording,
            ),
          );
  }
}
