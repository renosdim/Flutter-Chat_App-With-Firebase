import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/read_message_format.dart';
import 'package:flutter/cupertino.dart';

abstract class MessageBubbleFormat extends StatelessWidget{
  final bool? mine;
  final bool? last;
  final String? content;
  final List<MessageAlreadyReadFormat>? read;
  final String? pic;
  final bool? consecutive;
  final DateTime? previousMessageTimestamp;
  final DateTime? timestamp;
  final String? header;
  final Function(MessageBubbleFormat)? replyTo;
  final MessageBubbleFormat? replyFor;

  const MessageBubbleFormat({this.mine, this.last, this.content, this.read,super.key, this.pic, this.header, this.replyTo, this.replyFor, this.consecutive, this.previousMessageTimestamp, this.timestamp})
        ;


  @override
  Widget build(BuildContext context);
  MessageBubbleFormat copyWith(
      {MessageBubbleFormat? replyFor,
        bool? consecutive,
        DateTime? timestamp,
        DateTime? previousMessageTimestamp,
        Function(MessageBubbleFormat)? replyTo,
        bool? mine,
        bool? last,
        String? content,
        List<MessageAlreadyReadFormat>? read,
        String? pic,
        String? header,
        Key?  key});

}