import 'dart:async';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:intl/intl.dart';

class RecordBubble extends StatefulWidget {
  final MessageModel o;

  const RecordBubble({super.key, required this.o});

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

class AudioPlayerState extends State<RecordBubble> {
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
            decoration: BoxDecoration(
              color: baseColor1,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 55,
            width: 220,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: <Widget>[
                      playIcon(),
                      sliderLine(),
                      const Icon(Icons.mic, color: Colors.white),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, bottom: 2),
                    child: Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )),
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
    await audioPlayer.setSource(
        ap.DeviceFileSource(widget.o.file!.recordData!)); // Preload file
    await audioPlayer.resume(); // Start playing
  }

  Future<void> pause() => audioPlayer.pause();

  Future<void> stop() => audioPlayer.stop();
}
