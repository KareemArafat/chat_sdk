import 'package:chat_sdk/consts.dart';
import 'package:chat_sdk/models/message_model.dart';
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
            height: MediaQuery.of(context).size.height / 2.74,
            width: MediaQuery.of(context).size.width / 2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              color: baseColor1,
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      child: o.file!.path == null
                          ? Image.memory(
                              o.file!.dataSend,
                              fit: BoxFit.cover,
                            )
                          : Image.asset('assets/images/image.jpg'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )),
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