import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';

import '../immutable/formats/message_bubble_format.dart';
import '../immutable/formats/read_message_format.dart';
import 'dart:async';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/material.dart';

class PeriodicUpdateWrapper extends StatefulWidget {
  final Widget Function(BuildContext context) builder; // Use a builder function
  final Duration updateInterval;

  const PeriodicUpdateWrapper({
    required this.builder,
    required this.updateInterval,
    Key? key,
  }) : super(key: key);

  @override
  _PeriodicUpdateWrapperState createState() => _PeriodicUpdateWrapperState();
}

class _PeriodicUpdateWrapperState extends State<PeriodicUpdateWrapper> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Start the timer to periodically update the widget state
    _timer = Timer.periodic(widget.updateInterval, (Timer timer) {
      if (mounted) {
        setState(() {
          // This will trigger a rebuild of the widget
          print('trigger update');
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context); // Call the builder function to rebuild
  }
}

class AdaptiveChatBubble extends MessageBubbleFormat {
  const AdaptiveChatBubble({
    super.mine,
    super.consecutive,
    super.previousMessageTimestamp,
    super.replyTo,
    super.replyFor,
    super.last,
    super.timestamp,
    super.content,
    super.read,
    super.pic,
    super.header,
    super.key,
  });

  // Helper to format datetime based on the rules
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 24 && now.day == timestamp.day) {
      // Same day
      return "Today, " + DateFormat.jm().format(timestamp);
    } else if (difference.inHours < 48 && now.day - timestamp.day == 1) {
      // Yesterday
      return "Yesterday, " + DateFormat.jm().format(timestamp);
    } else if (difference.inDays < 7) {
      // Same week
      return DateFormat.EEEE().format(timestamp) + ", " + DateFormat.jm().format(timestamp);
    } else {
      // More than a week ago, show full date and time
      return DateFormat.yMMMd().format(timestamp) + ", " + DateFormat.jm().format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSender = mine ?? false; // Determine if it's a sent or received message
    bool showTail = last ?? false;

    // Calculate whether we should show the timestamp line
    bool showTimestampLine = false;
    if (timestamp != null && previousMessageTimestamp != null) {
      final timeDifference = timestamp!.difference(previousMessageTimestamp!);
      showTimestampLine = timeDifference.inMinutes > 60; // Check if more than 1 hour apart
    }
    else{
      showTimestampLine = true;
    }

    return SwipeTo(
      rightSwipeWidget: Text('Swipe to reply', style: TextStyle(color: Colors.grey[400])),
      onRightSwipe: (details) {
        replyTo!(this);
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 8.0,
          left: isSender ? 0 : 10.0,
          right: isSender ? 10.0 : 0,
        ),
        child: Column(
          crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // If we need to show the timestamp line, add it above the message
            if (showTimestampLine)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    _formatTimestamp(timestamp!), // Call the timestamp formatting helper
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // If replying to a message, show the "replyFor" message bubble
            if (replyFor != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: EdgeInsets.only(
                    bottom: 5.0, left: isSender ? 0 : 28.0, right: isSender ? 28.0 : 0),
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Subtle background color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2), // Shadow effect
                    ),
                  ],
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75, // Limited width
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display sender's name
                    Text(
                      replyFor!.header!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Bold name
                        color: Colors.black87, // Text color
                        fontSize: 14, // Adjust size
                      ),
                    ),
                    const SizedBox(height: 4), // Space between name and message
                    Text(
                      replyFor!.content!, // Display the content being replied to
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis, // Handle long text gracefully
                    ),
                  ],
                ),
              ),

            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: isSender ? 0 : 28.0, // Align bubble for receivers
                  ),
                  child: AnimatedContainer(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isSender
                          ? Colors.deepPurple // Sender's message color
                          : Colors.grey[200], // Receiver's message color
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSender
                          ? [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                        ),
                      ]
                          : [],
                      border: isSender
                          ? null
                          : Border.all(color: Colors.grey[300]!),
                    ),
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      content!,
                      style: GoogleFonts.openSans(
                        color: isSender ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                if (!isSender) // Profile pic for receiver messages
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(pic!),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // Show timestamp and potentially the "read" avatar
            Row(
              mainAxisAlignment:
              isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isSender) const SizedBox(width: 45),

                if (isSender && last == true) // Show read avatar for the sender's message
                  Row(
                    children: read!,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  MessageBubbleFormat copyWith({
    bool? mine,
    MessageBubbleFormat? replyFor,
    Function(MessageBubbleFormat)? replyTo,
    bool? consecutive,
    DateTime? previousMessageTimestamp,
    bool? last,
    DateTime? timestamp,
    String? content,
    List<MessageAlreadyReadFormat>? read,
    String? pic,
    String? header,
    Key? key,
  }) {
    return AdaptiveChatBubble(
      timestamp: timestamp ?? this.timestamp,
      previousMessageTimestamp: previousMessageTimestamp ?? this.previousMessageTimestamp,
      consecutive: consecutive ?? this.consecutive,
      replyFor: replyFor ?? this.replyFor,
      key: key ?? this.key,
      mine: mine ?? this.mine,
      last: last ?? this.last,
      content: content ?? this.content,
      replyTo: replyTo ?? this.replyTo,
      read: read ?? this.read,
      pic: pic ?? this.pic,
      header: header ?? this.header,
    );
  }
}
