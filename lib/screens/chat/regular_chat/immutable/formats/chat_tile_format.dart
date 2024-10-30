import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chat_tile_last_message_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/pic_widget_format.dart';
import 'package:flutter/material.dart';
abstract class ChatTileFormat extends StatelessWidget {

  //final String chatroomId;
  final ChatTileLastMessageFormat? lastMessage;
  final String? header;
  final PicWidgetFormat? pic;
  final VoidCallback? onChatroomPressed;

  const ChatTileFormat({
    Key? key,
    this.lastMessage,
    this.header,
    this.pic,

    this.onChatroomPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context);


  ChatTileFormat copyWith({
    required ChatTileLastMessageFormat? lastMessage,
    required String? header,
    required PicWidgetFormat? pic,
    required VoidCallback? onChatroomPressed,
  });

}