import 'dart:developer';
import 'dart:io';
import 'package:chat_sdk/core/consts.dart';
import 'package:chat_sdk/SDK/models/message_model.dart';
import 'package:chat_sdk/SDK/services/message_service.dart';
import 'package:chat_sdk/core/shardP/shard_p_model.dart';
import 'package:chat_sdk/ui/bubbles_ui/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileBubble extends StatelessWidget {
  const FileBubble({super.key, required this.o, required this.isMe});
  final MessageModel o;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.bottomLeft : Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
            height: MediaQuery.of(context).size.height / 5.2,
            width: MediaQuery.of(context).size.width / 2.7,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isMe ? baseColor1 : baseAppBarColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomRight: isMe ? const Radius.circular(30) : Radius.zero,
                bottomLeft: isMe ? Radius.zero : const Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final tempDir = await getTemporaryDirectory();
                    final file = File('${tempDir.path}/${o.file!.name}');
                    await file.writeAsBytes(o.file!.dataSend! as List<int>);
                    await OpenFilex.open(file.path);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset(
                          'assets/images/file.jpg',
                          //   height: MediaQuery.of(context).size.height / 6.19,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          child: Text('Open',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const TimeWidget(),
              ],
            )),
      ),
    );
  }
}

class FileView extends StatefulWidget {
  const FileView({super.key, required this.o});
  final MessageModel o;

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.asset('assets/images/file.jpg'),
          widget.o.file!.path != null
              ? const Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 6),
                  child: Text('Open',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                )
              : isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(right: 5, bottom: 6),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        strokeAlign: -5,
                      ),
                    )
                  : IconButton(
                      onPressed: () async {
                        isLoading = true;
                        setState(() {});
                        try {
                          String token = await ShardpModel().getToken();
                          widget.o.file!.dataSend = await MessageService().downloadFiles(
                              path: widget.o.file!.path!, token: token);
                          widget.o.file!.path = null;
                          isLoading = false;
                          setState(() {});
                        } catch (e) {
                          log('error .. ${e.toString()}');
                          isLoading = false;
                        }
                      },
                      icon: const Icon(
                        Icons.download_sharp,
                        size: 30,
                      ),
                    ),
        ],
      ),
    );
  }
}
