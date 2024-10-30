
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/pic_widget_format.dart';
import 'package:flutter/cupertino.dart';

import 'message_bubble_format.dart';

abstract class ChatroomContentFormat extends StatelessWidget{

  final List<MessageBubbleFormat>? messages;
  final PicWidgetFormat? pic;
  final String? header;
  final MessageBubbleFormat? replyingTo;
  final Future<void> Function(String,String?)? sendMessage;
  const ChatroomContentFormat({super.key,this.messages, this.pic,this.header, this.sendMessage, this.replyingTo});

  @override
  Widget build(BuildContext context);

  ChatroomContentFormat copyWith({
    List<MessageBubbleFormat>? messages,
    PicWidgetFormat? pic,
    String? header,
    MessageBubbleFormat? replyingTo,
    Future<void> Function(String,String?)? sendMessage,
  });


}