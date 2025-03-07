// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

// class VoiceMessageBubble extends StatefulWidget {
//   final String audioUrl; // URL or local path of the audio file
//   final Duration duration;
//   final bool isMe;

//   const VoiceMessageBubble({
//     Key? key,
//     required this.audioUrl,
//     required this.duration,
//     this.isMe = true,
//   }) : super(key: key);

//   @override
//   _VoiceMessageBubbleState createState() => _VoiceMessageBubbleState();
// }

// class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//   Duration currentPosition = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer.onPositionChanged.listen((Duration p) {
//       setState(() => currentPosition = p);
//     });
//     _audioPlayer.onPlayerComplete.listen((_) {
//       setState(() {
//         isPlaying = false;
//         currentPosition = Duration.zero;
//       });
//     });
//   }

//   Future<void> _togglePlayPause() async {
//     if (isPlaying) {
//       await _audioPlayer.pause();
//     } else {
//       await _audioPlayer.play(UrlSource(widget.audioUrl));
//     }
//     setState(() => isPlaying = !isPlaying);
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         padding: EdgeInsets.all(10),
//         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         decoration: BoxDecoration(
//           color: widget.isMe ? Colors.blueAccent : Colors.grey[300],
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             IconButton(
//               icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
//               onPressed: _togglePlayPause,
//             ),
//             Text(
//               "${currentPosition.inSeconds} / ${widget.duration.inSeconds} sec",
//               style: TextStyle(color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }