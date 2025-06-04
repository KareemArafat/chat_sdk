import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_sdk/cubits/chat_cubit/chat_state.dart';
import 'package:chat_sdk/models/message_model.dart';
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
        showReactionBox(context, details.globalPosition, o.messageId!, isMe);
      },
      child: Align(
        alignment: isMe ? Alignment.bottomLeft : Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IntrinsicWidth(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 14, right: 14),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(30),
                      topRight: const Radius.circular(30),
                      bottomRight:
                          isMe ? const Radius.circular(30) : Radius.zero,
                      bottomLeft:
                          isMe ? Radius.zero : const Radius.circular(30),
                    ),
                    color: isMe ? baseColor1 : baseAppBarColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          o.text ?? '',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
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
                      o.reacts ??= [];
                      if (!o.reacts!.contains(state.react)) {
                        o.reacts!.add(state.react);
                      }
                    }
                  }
                },
                builder: (context, state) {
                  if (o.reacts != null) {
                    return Positioned(
                      bottom: -11,
                      left: isMe ? 18 : null,
                      right: isMe ? null : 18,
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
                          children: o.reacts!
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
