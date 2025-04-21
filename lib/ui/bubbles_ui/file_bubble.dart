import 'dart:developer';
import 'dart:io';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/services/api/get_file.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileBubbleL extends StatelessWidget {
  const FileBubbleL({super.key, required this.o});
  final MessageModel o;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
            height: MediaQuery.of(context).size.height / 5.2,
            width: MediaQuery.of(context).size.width / 2.7,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: baseColor1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
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
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 6),
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
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class FileBubbleR extends StatefulWidget {
  const FileBubbleR({super.key, required this.o});
  final MessageModel o;

  @override
  State<FileBubbleR> createState() => _FileBubbleRState();
}

class _FileBubbleRState extends State<FileBubbleR> {
  String isLoading = 'false';
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
            height: MediaQuery.of(context).size.height / 4.9,
            width: MediaQuery.of(context).size.width / 2.7,
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: baseAppBarColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (widget.o.file!.path == null) {
                            final tempDir = await getTemporaryDirectory();
                            final file =
                                File('${tempDir.path}/${widget.o.file!.name}');
                            await file.writeAsBytes(
                                widget.o.file!.dataSend! as List<int>);
                            await OpenFilex.open(file.path);
                          } else {
                            log('not Loaded');
                          }
                        },
                        child: Image.asset(
                          'assets/images/file.jpg',
                        ),
                      ),
                      isLoading == 'true'
                          ? const Padding(
                              padding: EdgeInsets.only(right: 5, bottom: 6),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                strokeAlign: -5,
                              ),
                            )
                          : isLoading == 'false'
                              ? IconButton(
                                  onPressed: () async {
                                    isLoading = 'true';
                                    setState(() {});
                                    try {
                                      String token =
                                          await ShardpModel().getToken();
                                      widget.o.file!.dataSend =
                                          await LoadFiles().getFileFn(
                                              path: widget.o.file!.path!,
                                              token: token);
                                      widget.o.file!.path = null;
                                      isLoading = 'done';
                                      setState(() {});
                                    } catch (e) {
                                      log('error .. ${e.toString()}');
                                      isLoading = 'false';
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.download_sharp,
                                    size: 30,
                                  ))
                              : const Padding(
                                  padding: EdgeInsets.only(top: 5, bottom: 6),
                                  child: Center(
                                    child: Text('Open',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
