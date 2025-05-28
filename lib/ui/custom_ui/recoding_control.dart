import 'package:chat_sdk/core/consts.dart';
import 'package:flutter/material.dart';

class RecordingControls extends StatelessWidget {
  final Duration duration;
  final VoidCallback onStop;
  final VoidCallback onCancel;

  const RecordingControls(
      {super.key,
      required this.duration,
      required this.onStop,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 30),
          onPressed: onCancel,
        ),
        const SizedBox(width: 20),
        Text(
          "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: onStop,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: baseColor2,
            ),
            padding: const EdgeInsets.all(15),
            child:
                const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
