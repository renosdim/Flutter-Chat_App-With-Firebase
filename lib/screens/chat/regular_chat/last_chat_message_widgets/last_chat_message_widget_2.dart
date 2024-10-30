import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/chat_bubbles/regular_adaptive_chat_bubble_1.dart';
import 'package:flutter/material.dart';

import '../immutable/formats/chat_tile_last_message_format.dart';


class SnapchatStyleMessageWidget extends ChatTileLastMessageFormat {
  const SnapchatStyleMessageWidget({
    super.key,
    super.read,
    super.mine,
    super.typing,
    super.timestamp,
    super.unreadCount,
  });

  // Format the timestamp as "x minutes ago," "x hours ago," etc.
  String _formatTimestamp(DateTime? timestamp) {
    if(timestamp==null){
      return '';
    }
    Duration timeAgo = DateTime.now().difference(timestamp);
    if (timeAgo.inDays > 0) {
      return '${timeAgo.inDays}d ';
    } else if (timeAgo.inHours > 0) {
      return '${timeAgo.inHours}h ';
    } else if (timeAgo.inMinutes > 0) {
      return '${timeAgo.inMinutes}m ';
    } else {
      return 'just now';
    }
  }

  // Helper method to select the right status message and icon
  Widget _buildStatusAndIcon() {
    if (typing == true) {
      return _buildTypingStatus();
    } else if (mine == true) {
      return _buildSentMessageStatus();  // For sent messages
    } else {
      return _buildReceivedMessageStatus();  // For received messages
    }
  }

  // Typing status
  Widget _buildTypingStatus() {
    return Row(
      children: [
        Text(
          "Typing...",
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      ],
    );
  }

  // Sent message statuses
  Widget _buildSentMessageStatus() {
    String status;
    Icon icon;
    Color? color = Colors.grey[600];
    bool bold = false;

    if (read == true) {
      status = 'Opened';

      icon = Icon(Icons.send_outlined, color: Colors.blue, size: 14);  // Hollow arrow for opened
    } else {
      status = 'Delivered';

      icon = Icon(Icons.send_outlined, color: Colors.blueAccent, size: 14, fill: 1); // Solid blue arrow for delivered
    }

    return Row(
      children: [
        icon,
        SizedBox(width: 5),
        Text(
          status,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }

  // Received message statuses
  Widget _buildReceivedMessageStatus() {
    String status;
    Icon icon;
    MaterialColor color = Colors.grey;
    bool bold = false;

    if (read == true) {
      status = 'Received';
      icon = Icon(Icons.chat_bubble_outline, color: Colors.blue, size: 14);  // Hollow chat bubble for read
    } else {
      status = 'New Chat';
      color=Colors.blue;
      bold = true;
      icon = Icon(Icons.chat_bubble, color: Colors.blueAccent, size: 14); // Solid chat bubble for new chat
    }

    return Row(
      children: [
        icon,
        SizedBox(width: 5),
        Text(
          status,
          style: TextStyle(color:color, fontSize: 14,fontWeight:bold? FontWeight.bold:null),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PeriodicUpdateWrapper(
      updateInterval: Duration(minutes: 2),
      builder:(context) {
        print(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Message status and icon (e.g., Delivered, Opened, etc.)
            _buildStatusAndIcon(),
            SizedBox(width: 5),
            // Timestamp showing how long ago the message was sent
            Text(
              _formatTimestamp(timestamp!),
              // Display how long ago the message was sent
              style: TextStyle(
                color: Colors.grey[500], // Timestamp in a slightly darker grey
                fontSize: 14,
              ),
            ),
          ],
        )
        ;
      }
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
    bool? typing,
    int? unreadCount
  }) {
    return SnapchatStyleMessageWidget(
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
      mine: mine ?? this.mine,
      unreadCount: unreadCount??this.unreadCount,
      typing: typing ?? this.typing,
    );
  }
}
