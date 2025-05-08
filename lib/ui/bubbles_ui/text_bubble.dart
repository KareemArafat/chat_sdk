import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/ui/bubbles_ui/react_box.dart';
import 'package:chat_sdk/ui/bubbles_ui/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextBubble extends StatefulWidget {
  const TextBubble({super.key, required this.o, required this.isMe});
  final MessageModel o;
  final bool isMe;

  @override
  State<TextBubble> createState() => _TextBubbleState();
}

class _TextBubbleState extends State<TextBubble> {
  static OverlayEntry? activeOverlayEntry; // Shared across all bubbles
  String? selectedEmoji;

  void showReactionBox(Offset offset) {
    activeOverlayEntry?.remove();
    activeOverlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                activeOverlayEntry?.remove();
                activeOverlayEntry = null;
              },
              child: Container(),
            ),
          ),
          Positioned(
            top: offset.dy - 70,
            child: Material(
              color: Colors.transparent,
              child: ReactionBox(
                onReact: (emoji) {
                  setState(() {
                    selectedEmoji = emoji;
                  });
                  activeOverlayEntry?.remove();
                  activeOverlayEntry = null;
                },
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(activeOverlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        showReactionBox(details.globalPosition);
      },
      child: Align(
        alignment: widget.isMe ? Alignment.bottomLeft : Alignment.bottomRight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30),
                    topRight: const Radius.circular(30),
                    bottomRight:
                        widget.isMe ? const Radius.circular(30) : Radius.zero,
                    bottomLeft:
                        widget.isMe ? Radius.zero : const Radius.circular(30),
                  ),
                  color: widget.isMe ? baseColor1 : baseAppBarColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 4, bottom: 4, right: 50),
                      child: Text(
                        widget.o.text ?? '',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    TimeWidget(time: timeFn()),
                  ],
                ),
              ),
            ),
            if (selectedEmoji != null)
              Positioned(
                bottom: -4,
                left: widget.isMe ? null : 0,
                right: widget.isMe ? 0 : null,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    selectedEmoji!,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String timeFn() {
    if (widget.o.time == null) {
      widget.o.time = DateFormat('hh:mm a').format(DateTime.now());
      return widget.o.time!;
    } else if (widget.o.time!.length > 10) {
      DateTime dateTime = DateTime.parse(widget.o.time!);
      widget.o.time = DateFormat('hh:mm a').format(dateTime);
      return widget.o.time!;
    } else {
      return widget.o.time!;
    }
  }
}
