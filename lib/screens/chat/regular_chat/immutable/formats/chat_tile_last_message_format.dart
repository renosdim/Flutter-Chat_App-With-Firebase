import 'package:flutter/material.dart';

abstract class ChatTileLastMessageFormat extends StatelessWidget {
  final bool? read;
  final bool? mine;
  final String? senderName;
  final int? unreadCount;
  final String? senderUsername;
  final String? content;
  final bool? typing;
  final DateTime? timestamp;

  const ChatTileLastMessageFormat({
    super.key,
    this.read,
    this.mine,

    this.typing, this.content, this.timestamp, this.senderName, this.senderUsername, this.unreadCount,
  });

  @override
  Widget build(BuildContext context);

  // Implementing the copyWith function
  ChatTileLastMessageFormat copyWith({
    DateTime? timestamp,
    String? content,
    bool? read,
    bool? mine,
    int? unreadCount,
    String? senderName,
    String? senderUsername,
    bool? typing,
  });
}