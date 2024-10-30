import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/read_message_format.dart';
import 'package:flutter/material.dart';

class MessageAlreadyRead1 extends MessageAlreadyReadFormat{
  const MessageAlreadyRead1({super.key,super.name,super.username,super.pic,super.timestamp});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: CircleAvatar(
        radius: 10,
        backgroundImage: NetworkImage(pic!), // Show the profile pic if read
      ),
    );
  }

  @override
  MessageAlreadyReadFormat copyWith({String? username, String? name, String? pic, DateTime? timestamp}) {
    // TODO: implement copyWith
    return MessageAlreadyRead1(
      username: username??this.username,
      name: name??this.name,
      pic: pic??this.pic,
      timestamp: timestamp??this.timestamp,
    );
  }


}