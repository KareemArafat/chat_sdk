import 'package:flutter/material.dart';

class ReactionBox extends StatelessWidget {
  const ReactionBox({super.key, required this.onReact});
  final void Function(String emoji) onReact;

  @override
  Widget build(BuildContext context) {
    final emojis = ['👍', '❤️', '😂', '😮', '😢', '👏'];

    return Card(
      elevation: 6,
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: emojis.map((emoji) {
            return GestureDetector(
              onTap: () => onReact(emoji),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

void showReactionBox(BuildContext context, Offset offset,
    OverlayEntry? activeOverlay, String? selectedEmoji) {
  activeOverlay?.remove();
  activeOverlay = OverlayEntry(
    builder: (context) => Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              activeOverlay!.remove();
              activeOverlay = null;
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
                selectedEmoji = emoji;
                activeOverlay!.remove();
                activeOverlay = null;
              },
            ),
          ),
        ),
      ],
    ),
  );
  Overlay.of(context).insert(activeOverlay!);
}
