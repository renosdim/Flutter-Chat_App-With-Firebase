
import 'package:equatable/equatable.dart';

abstract class Message extends Equatable{
  final String senderUid;

  final String receiverUid;
  final String message;
  final int timestamp;
  final bool read;
  final bool? unsent;
  final String? replyForMessageKey;
  final String key;

  const Message({required this.senderUid,

    required this.receiverUid,
    required this.message
    ,required this.timestamp,
    this.unsent,
    this.replyForMessageKey,
    required this.read,required this.key});

  @override
  // TODO: implement props
  List<Object?> get props => [message,timestamp,read,unsent];
}