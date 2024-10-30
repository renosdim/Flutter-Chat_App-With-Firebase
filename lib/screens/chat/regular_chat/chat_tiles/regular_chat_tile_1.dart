import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chat_tile_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chat_tile_last_message_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/pic_widget_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ChatTile1 extends ChatTileFormat {
  const ChatTile1({super.key,super.lastMessage,super.header,super.onChatroomPressed,super.pic});




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () {
            onChatroomPressed!();
            // Navigate to chat screen (add your navigation logic here)
          },
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black54, // Dark background

            ),
            child: Row(
              children: [
                pic!,
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          header!,
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleLarge
                      ),
                      SizedBox(height: 5),
                      lastMessage ?? Text('no messages')
                    ],
                  ),
                ),
                SizedBox(width: 10),

              ],
            ),
          ),
        );



  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  @override
  ChatTileFormat copyWith({
    ChatTileLastMessageFormat? lastMessage,
    String? header,
    PicWidgetFormat? pic,
    VoidCallback? onChatroomPressed,
  }) {
    return ChatTile1(
      lastMessage: lastMessage ?? this.lastMessage,  // Use new value if provided, otherwise fallback to the current one
      header: header ?? this.header,                       // Same pattern for other properties
      pic: pic ?? this.pic,
      onChatroomPressed: onChatroomPressed ?? this.onChatroomPressed,
    );
  }

}

















