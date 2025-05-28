import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReactionBox extends StatelessWidget {
  const ReactionBox({super.key, required this.onReact});
  final Function onReact;

  @override
  Widget build(BuildContext context) {
    final emojisList = ['👍', '❤️', '😂', '😮', '😢', '👏'];

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: emojisList.map((emoji) {
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

void showReactionBox(
    BuildContext context, Offset offset, String messId, bool isMe) {
  OverlayEntry? activeOverlay;
  activeOverlay = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                activeOverlay!.remove();
                activeOverlay = null;
              },
              onLongPress: () {
                activeOverlay!.remove();
                activeOverlay = null;
              },
            ),
          ),
          Positioned(
            top: offset.dy - 70,
            left: isMe
                ? offset.dx - 70
                : offset.dx - 220,
            child: ReactionBox(
              onReact: (emoji) {
                BlocProvider.of<ChatCubit>(context)
                    .sendReact(react: emoji, messId: messId);
                activeOverlay!.remove();
                activeOverlay = null;
              },
            ),
          ),
        ],
      );
    },
  );
  Overlay.of(context).insert(activeOverlay!);
}
