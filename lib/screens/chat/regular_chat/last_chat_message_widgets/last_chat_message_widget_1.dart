
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chat_tile_last_message_format.dart';
import 'package:flutter/material.dart';
class FullMessageInfoWidget extends ChatTileLastMessageFormat {
  const FullMessageInfoWidget({
    super.key,
    super.read,
    super.mine,
    super.typing,
    super.content,
    super.timestamp,
    super.senderName,
    super.senderUsername,
    super.unreadCount,
  });

  String _formatTimestamp(DateTime timestamp) {
    Duration timeAgo = DateTime.now().difference(timestamp);
    if (timeAgo.inDays > 0) {
      return '${timeAgo.inDays}d ago';
    } else if (timeAgo.inHours > 0) {
      return '${timeAgo.inHours}h ago';
    } else if (timeAgo.inMinutes > 0) {
      return '${timeAgo.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the sender display (name or username) if the message isn't the user's
    String? senderDisplay = !mine! ? (senderName ?? senderUsername) : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // If the message isn't from the current user, show the sender's name/username
        if (senderDisplay != null) ...[
          Text(
            '$senderDisplay: ',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
        Expanded(
          child: Text(
            content??'',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: mine! ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          _formatTimestamp(timestamp!),
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }

  @override
  ChatTileLastMessageFormat copyWith({
    DateTime? timestamp,
    String? content,
    bool? read,
    bool? mine,
    String? senderName,
    String? senderUsername,
    int? unreadCount,
    bool? typing,
  }) {
    return FullMessageInfoWidget(
      timestamp: timestamp ?? this.timestamp,
      content: content ?? this.content,
      unreadCount: unreadCount??this.unreadCount,
      read: read ?? this.read,
      mine: mine ?? this.mine,
      senderName: senderName ?? this.senderName,
      senderUsername: senderUsername ?? this.senderUsername,
      typing: typing ?? this.typing,
    );
  }
}