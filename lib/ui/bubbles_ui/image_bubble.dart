import 'dart:developer';
import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
import 'package:chat_sdk/services/api/get_file.dart';
import 'package:chat_sdk/services/shardP/shard_p_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImageBubbleL extends StatelessWidget {
  const ImageBubbleL({super.key, required this.o});
  final MessageModel o;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            color: baseColor1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Makes column take as little vertical space as needed
            children: [
              ImageView(o: o),
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
          ),
        ),
      ),
    );
  }
}

class ImageView extends StatefulWidget {
  const ImageView({
    super.key,
    required this.o,
  });

  final MessageModel o;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: widget.o.file!.path == null
          ? Image.memory(
              widget.o.file!.dataSend!,
              fit: BoxFit.contain,
            )
          : Stack(
              alignment: Alignment.bottomRight,
              children: [
                Image.asset(
                  'assets/images/image.jpg',
                  fit: BoxFit.contain,
                ),
                isLoading
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
                            widget.o.file!.dataSend = await LoadFiles()
                                .getFileFn(
                                    path: widget.o.file!.path!, token: token);
                            widget.o.file!.path = null;
                            isLoading = false;
                            setState(() {});
                          } catch (e) {
                            log('error .. ${e.toString()}');
                            isLoading = false;
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.download_sharp,
                          size: 30,
                        ))
              ],
            ),
    );
  }
}


// class ImageBubbleR extends StatelessWidget {
//   const ImageBubbleR({super.key, required this.o});
//   final MessageModel o;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//         child: Container(
//             height: MediaQuery.of(context).size.height / 2.74,
//             width: MediaQuery.of(context).size.width / 2,
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(15),
//                   topRight: Radius.circular(15),
//                   bottomLeft: Radius.circular(15)),
//               color: Color.fromARGB(255, 89, 87, 87),
//             ),
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(15),
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     clipBehavior: Clip.hardEdge,
//                     child: SizedBox(
//                       child: Image.memory(
//                         o.file!.dataSend,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomRight,
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: Text(
//                       DateFormat('hh:mm a').format(DateTime.now()),
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             )),
//       ),
//     );
//   }
// }