
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'common/typo.dart';

class ReceiverRowView extends StatelessWidget {
  final dynamic message;
  final String profilePic;
  final String? name;

  const ReceiverRowView({
    Key? key,
    required this.message,
    required this.profilePic,
    required this.name,
  }) : super(key: key);

  String _formatDateTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    bool tail = false;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 8.0), // Padding for receiver
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align everything to the left
        children: [
          // Display the sender's name above the message
          name != null
              ? Padding(
            padding: const EdgeInsets.only(left: 40.0, bottom: 5),
            child: Text(
              name!,
              style: h4, // Assuming `h4` is a predefined text style
            ),
          )
              : Container(),
          Stack(
            children: [
              // Chat bubble with the message text
              Padding(
                padding: const EdgeInsets.only(left: 28.0), // Indent bubble from profile pic
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Light background for received messages
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Positioned profile picture on the left side of the chat bubble
              Positioned(
                left: 0, // Align the profile picture to the far left
                bottom: 0,
                child: CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(profilePic),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          // If the tail is true, show the timestamp below the message bubble
          tail == true
              ? Row(
            mainAxisAlignment: MainAxisAlignment.start, // Align the timestamp to the left
            children: [
              SizedBox(width: 45), // Add space to align with the bubble's indent
              Text(
                _formatDateTime(DateTime.fromMillisecondsSinceEpoch(message.timestamp)),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          )
              : Container(),
        ],
      ),
    );
  }
}