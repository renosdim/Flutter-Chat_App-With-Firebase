import 'package:flutter/cupertino.dart';

abstract class MessageAlreadyReadFormat extends StatelessWidget{
  final String? username;
  final String? name;
  final String? pic;
  final DateTime? timestamp;
  const MessageAlreadyReadFormat({super.key, this.username, this.name, this.pic, this.timestamp});


  @override
  Widget build(BuildContext context) ;

  MessageAlreadyReadFormat copyWith({String? username,String? name,String? pic,DateTime? timestamp});

}