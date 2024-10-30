// import 'package:flutter/material.dart';
//
// import '../immutable/formats/message_bubble_format.dart';
//
// class ChatBubble extends MessageBubbleFormat {
//   const ChatBubble({
//     bool? mine,
//     bool? last,
//     String? content,
//     bool? read,
//     String? pic,
//     String? header,
//     Function(MessageBubbleFormat)? replyTo,
//     MessageBubbleFormat? replyFor,
//     Key? key,
//   }) : super(
//     mine: mine,
//     last: last,
//     content: content,
//     read: read,
//     pic: pic,
//     header: header,
//     replyTo: replyTo,
//     replyFor: replyFor,
//     key: key,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: mine == true ? MainAxisAlignment.end : MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (mine == false && pic != null) CircleAvatar(backgroundImage: NetworkImage(pic!)),
//         Flexible(
//           child: Column(
//             crossAxisAlignment: mine == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//             children: [
//               if (header != null)
//                 Text(
//                   header!,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               if (replyFor != null)
//                 Container(
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     replyFor!.content ?? '',
//                     style: TextStyle(
//                       fontStyle: FontStyle.italic,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ),
//               Container(
//                 margin: const EdgeInsets.symmetric(vertical: 5),
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: mine == true ? Colors.blue.shade100 : Colors.grey.shade300,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(15),
//                     topRight: Radius.circular(15),
//                     bottomLeft: Radius.circular(mine == true ? 15 : 0),
//                     bottomRight: Radius.circular(mine == true ? 0 : 15),
//                   ),
//                 ),
//                 child: Text(
//                   content ?? '',
//                   style: TextStyle(
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               if (last == true && mine == true && read == true)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 2),
//                   child: Text(
//                     'Read',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   MessageBubbleFormat copyWith({
//     bool? mine,
//     bool? last,
//     String? content,
//     bool? read,
//     String? pic,
//     String? header,
//     Function(MessageBubbleFormat)? replyTo,
//     MessageBubbleFormat? replyFor,
//     Key? key,
//   }) {
//     return ChatBubble(
//       mine: mine ?? this.mine,
//       last: last ?? this.last,
//       content: content ?? this.content,
//       read: read ?? this.read,
//       pic: pic ?? this.pic,
//       header: header ?? this.header,
//       replyTo: replyTo ?? this.replyTo,
//       replyFor: replyFor ?? this.replyFor,
//       key: key ?? this.key,
//     );
//   }
// }
