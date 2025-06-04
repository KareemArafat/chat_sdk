import 'dart:async';
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
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class SoundBubble extends StatefulWidget {
  const SoundBubble({
    super.key,
    required this.o,
    required this.isMe,
    required this.isVoice,
  });
  final MessageModel o;
  final bool isMe;
  final bool isVoice;

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

class AudioPlayerState extends State<SoundBubble> {
  final audioPlayer = ap.AudioPlayer();
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    super.initState();
    _playerStateChangedSubscription =
        audioPlayer.onPlayerComplete.listen((_) async {
      await stop();
      setState(() {});
    });
    _positionChangedSubscription = audioPlayer.onPositionChanged.listen(
      (position) => setState(() => _position = position),
    );
    _durationChangedSubscription = audioPlayer.onDurationChanged.listen(
      (duration) => setState(() => _duration = duration),
    );
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool initial = widget.o.file!.dataSend != null ? true : false;
    return GestureDetector(
      onLongPressStart: (details) {
        showReactionBox(
            context, details.globalPosition, widget.o.messageId!, widget.isMe);
      },
      child: Align(
        alignment: widget.isMe ? Alignment.bottomLeft : Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IntrinsicWidth(
                child: Container(
                    decoration: BoxDecoration(
                      color: widget.isMe ? baseColor1 : baseAppBarColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    height: 60,
                    width: 230,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: <Widget>[
                              initial
                                  ? playIcon()
                                  : GestureDetector(
                                      onTap: () async {
                                        try {
                                          String token =
                                              await ShardpModel().getToken();
                                          widget.o.file!.dataSend =
                                              await MessageService()
                                                  .downloadFiles(
                                                      path:
                                                          widget.o.file!.path!,
                                                      token: token);
                                          setState(() {});
                                        } catch (e) {
                                          log('error .. ${e.toString()}');
                                        }
                                      },
                                      child: const Icon(
                                        Icons.download_sharp,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    ),
                              sliderLine(),
                              widget.isVoice
                                  ? const Icon(Icons.mic, color: Colors.white)
                                  : const Icon(Icons.music_note_rounded,
                                      color: Colors.white)
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: TimeWidget(),
                        ),
                      ],
                    )),
              ),
              BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ReactSuccess) {
                    if (widget.o.messageId == state.messId) {
                      widget.o.reacts ??= [];
                      if (!widget.o.reacts!.contains(state.react)) {
                        widget.o.reacts!.add(state.react);
                      }
                    }
                  }
                },
                builder: (context, state) {
                  if (widget.o.reacts != null) {
                    return Positioned(
                      bottom: -23,
                      left: widget.isMe ? 12 : null,
                      right: widget.isMe ? null : 12,
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
                          children: widget.o.reacts!
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

  Widget playIcon() {
    return GestureDetector(
      onTap: () {
        if (audioPlayer.state == ap.PlayerState.playing) {
          pause();
        } else {
          play();
        }
      },
      child: Icon(
        audioPlayer.state == ap.PlayerState.playing
            ? Icons.pause
            : Icons.play_arrow,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget sliderLine() {
    final duration = _duration;
    final position = _position;
    bool canSetValue = duration != null &&
        position != null &&
        position.inMilliseconds > 0 &&
        position.inMilliseconds < duration.inMilliseconds;
    return SizedBox(
      width: 140,
      child: Slider(
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play() async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/temp_audio.mp3');
    await file.writeAsBytes(widget.o.file!.dataSend! as List<int>, flush: true);
    await audioPlayer.setSource(ap.DeviceFileSource(file.path));
    await audioPlayer.resume();
  }

  Future<void> pause() => audioPlayer.pause();

  Future<void> stop() => audioPlayer.stop();
}
