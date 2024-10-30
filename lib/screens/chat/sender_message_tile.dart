


import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../operations/chat/regular_chat/domain/entities/message_entity.dart';
import 'common/typo.dart';
class SenderRowView extends StatelessWidget {
  final dynamic message;
  final String  profilePic;
  final bool? tail;
  const SenderRowView({Key? key, required this.message,required this.profilePic,this.tail}) : super(key: key);


  String _formatDateTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          BubbleSpecialThree(
            color: Theme.of(context).colorScheme.secondary,
            tail: tail??true,
             delivered: true,
             // Align the ChatBubble to the top right
            text:message.message,
            textStyle:messageColor),
    tail==true?(message.read==true?Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: CircleAvatar(radius: 8,backgroundImage: NetworkImage(profilePic),),
        ),
      ],
    ):Container()):Container(),
    ]
          )


      );





  }

  // }
}

class GradientChatBubble extends StatelessWidget {
  final dynamic message;
  final String profilePic;
  final bool? tail;

  const GradientChatBubble({
    Key? key,
    required this.message,
    required this.profilePic,
    this.tail,
  }) : super(key: key);

  String _formatDateTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purpleAccent, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: tail == true ? Radius.circular(18) : Radius.zero,
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(2, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(
              message.message,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 5),
          tail == true
              ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(profilePic),
                ),
              ),
              SizedBox(width: 5),
              Text(
               _formatDateTime(DateTime.fromMillisecondsSinceEpoch(message.timestamp)),
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          )
              : Container(),
        ],
      ),
    );
  }
}
class MinimalisticChatBubble extends StatelessWidget {
  final dynamic message;
  final String profilePic;
  final bool? tail;

  const MinimalisticChatBubble({
    Key? key,
    required this.message,
    required this.profilePic,
    this.tail,
  }) : super(key: key);

  String _formatDateTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedContainer(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(
        color:  Colors.deepPurple,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
        BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
          )]),
            duration:  Duration(milliseconds: 300),
            child: Text(
              message.message,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 4),
          tail == true
              ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  radius: 8,
                  backgroundImage: NetworkImage(profilePic),
                ),
              ),
              SizedBox(width: 6),
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