import 'dart:async';
import 'dart:developer';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordService {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _audioPath;
  Duration _recordingDuration = Duration.zero;
  Timer? _timer;
  Function(Duration)? onDurationUpdate;
  bool _isRecorderInitialized = false;

  RecordService({this.onDurationUpdate}) {
    _recorder = FlutterSoundRecorder();
  }

  Future<void> _initializeRecorder() async {
    _recorder ??= FlutterSoundRecorder();

    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception("Microphone permission not granted");
    }

    if (!_isRecorderInitialized) {
      // Only initialize once
      await _recorder!.openRecorder();
      _isRecorderInitialized = true; // Mark recorder as initialized
    }

    await _recorder!.setSubscriptionDuration(const Duration(milliseconds: 100));
  }

  Future<void> startRecording() async {
    try {
      await _initializeRecorder();

      final directory = await getApplicationDocumentsDirectory();
      _audioPath = '${directory.path}/recorded_audio.wav';

      await _recorder!.startRecorder(toFile: _audioPath, codec: Codec.pcm16WAV);

      _recordingDuration = Duration.zero;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordingDuration =
            Duration(seconds: _recordingDuration.inSeconds + 1);
        onDurationUpdate?.call(_recordingDuration);
      });

      _isRecording = true;
    } catch (e) {
      log("Error starting recorder: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      if (_recorder == null || !_isRecording) {
        log("Recorder is not recording");
        return;
      }

      await _recorder!.stopRecorder();
      _timer?.cancel();
      _isRecording = false;
    } catch (e) {
      log("Error stopping recorder: $e");
    }
  }

  void dispose() async {
    try {
      if (_recorder != null && _isRecorderInitialized) {
        await _recorder!.closeRecorder();
        _isRecorderInitialized = false; // Reset flag
      }
      _timer?.cancel();
    } catch (e) {
      log("Error disposing recorder: $e");
    }
  }

  bool get isRecording => _isRecording;
  String? get audioPath => _audioPath;
}
