import 'package:chat_sdk/cubits/rooms_cubit/rooms_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void menuSheet(BuildContext context, GlobalKey menuKey) {
  final RenderBox renderBox =
      menuKey.currentContext!.findRenderObject() as RenderBox;
  final Offset offset = renderBox.localToGlobal(Offset.zero);

  showMenu(
    context: context,
    color: const Color(0xFF1F1F1F),
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + renderBox.size.height,
      offset.dx,
      0,
    ),
    items: [
      menuItem(
          "Refresh", () => BlocProvider.of<RoomsCubit>(context).getRoomsList()),
    ],
  );
}

PopupMenuItem menuItem(String title, void Function()? tap) {
  return PopupMenuItem(
      onTap: tap,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ));
}
