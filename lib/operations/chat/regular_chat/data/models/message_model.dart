

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/failures/failure.dart';

import '../../domain/entities/message_entity.dart';

class MessageModel extends Message{
  MessageModel({required super.senderUid,super.replyForMessageKey,required super.key, required super.receiverUid, required super.message, required super.timestamp, required super.read});

  Map<String,Object?> toMap(){
    return {
      'senderUid':senderUid,
      'replyFor':replyForMessageKey,
      'receiverUid':receiverUid,
      'message':message,
      'timestamp':timestamp,
      'read':read};
  }
  factory MessageModel.fromSnapshot(dynamic snapshot,String key){
    print('chatroom model ${key}');
    if(snapshot['receiverUid']==null || snapshot['read'] is! bool){
      throw NotRegularChatFailure();
    }
    return MessageModel(senderUid: snapshot['senderUid'],
        replyForMessageKey: snapshot['replyFor'],
        receiverUid: snapshot['receiverUid'],
        message: snapshot['message'],
        timestamp: snapshot['timestamp'],
        read: snapshot['read']??false,
        key: key);
  }
}