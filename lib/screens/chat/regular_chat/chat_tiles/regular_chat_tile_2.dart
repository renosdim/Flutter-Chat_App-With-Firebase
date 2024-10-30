// import 'package:intl/intl.dart';
//
// import '../immutable/formats/chat_tile_format.dart';
// import 'package:flutter/material.dart';
//
// class GradientChatTile extends RegularChatTileFormat {
//   const GradientChatTile({
//     super.key,
//      dynamic lastMessage, String? name,
//     String? profilePic,
//     VoidCallback? onChatroomPressed,
//   }) : super(
//     lastMessage: lastMessage,
//     name: name,
//     profilePic: profilePic,
//     onChatroomPressed: onChatroomPressed,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       child: GestureDetector(
//         onTap: onChatroomPressed,
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade700],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 offset: Offset(0, 4),
//                 blurRadius: 6,
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 25,
//                 backgroundImage: NetworkImage(profilePic!),
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name!,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       lastMessage?.message ?? 'No messages yet',
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 14,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     _formatDateTime(DateTime.fromMillisecondsSinceEpoch(lastMessage?.timestamp ?? 0)),
//                     style: const TextStyle(
//                       color: Colors.white54,
//                       fontSize: 12,
//                     ),
//                   ),
//                   if (lastMessage != null && !lastMessage.read)
//                     Container(
//                       margin: const EdgeInsets.only(top: 4),
//                       height: 10,
//                       width: 10,
//                       decoration: const BoxDecoration(
//                         color: Colors.greenAccent,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _formatDateTime(DateTime dateTime) {
//     return DateFormat.jm().format(dateTime);
//   }
//
//   @override
//   RegularChatTileFormat copyWith({
//     required dynamic lastMessage,
//     required String? name,
//     required String? profilePic,
//     required VoidCallback? onChatroomPressed,
//   }) {
//     return GradientChatTile(
//       lastMessage: lastMessage,
//       name: name,
//       profilePic: profilePic,
//       onChatroomPressed: onChatroomPressed,
//     );
//   }
// }
