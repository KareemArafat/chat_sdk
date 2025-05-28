import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/SDK/models/message_model.dart';
import 'package:chat_sdk/ui/bubbles_ui/react_box.dart';
import 'package:chat_sdk/ui/bubbles_ui/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TextBubble extends StatelessWidget {
  const TextBubble({super.key, required this.o, required this.isMe});
  final MessageModel o;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        showReactionBox(context, details.globalPosition, o.messageId!,isMe);
      },
      child: Align(
        alignment: isMe ? Alignment.bottomLeft : Alignment.bottomRight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IntrinsicWidth(
              child: Container(
                padding:
                    const EdgeInsets.only(
                        top: 8, bottom: 6, left: 18, right: 10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30),
                    topRight: const Radius.circular(30),
                    bottomRight: isMe ? const Radius.circular(30) : Radius.zero,
                    bottomLeft: isMe ? Radius.zero : const Radius.circular(30),
                  ),
                  color: isMe ? baseColor1 : baseAppBarColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 4, bottom: 4, right: 50),
                      child: Text(
                        o.text ?? '',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    TimeWidget(time: formatTime(o.time)),
                  ],
                ),
              ),
            ),
            BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ReactSuccess) {
                  if (o.messageId == state.messId) {
                    o.reacts = [state.react];
                  }
                }
              },
              builder: (context, state) {
                if (o.reacts != null) {
                  return Positioned(
                    bottom: -4,
                    left: isMe ? null : 0,
                    right: isMe ? 0 : null,
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
                        o.reacts![0],
                        style: const TextStyle(fontSize: 18),
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
    );
  }

  String formatTime(String? time) {
    if (time == null) {
      return DateFormat('hh:mm a').format(DateTime.now());
    } else if (time.length > 10) {
      final dateTime = DateTime.tryParse(time);
      return dateTime != null ? DateFormat('hh:mm a').format(dateTime) : time;
    } else {
      return time;
    }
  }
}
