

import '../../domain/entities/grou_message_entity.dart';

class GroupMessageModel extends GroupMessage{
  GroupMessageModel({
    required super.receiverUids,
    required super.senderUid,

    required super.message,
    required super.timestamp,
    required super.read,
    required super.key
  });

  factory GroupMessageModel.fromSnapshot(dynamic snapshot,String key){
    return GroupMessageModel(
        receiverUids: snapshot['receiverUids']??[],
        senderUid: snapshot['senderUid'],
        message: snapshot['message'],
        timestamp: snapshot['timestamp'],
        read: snapshot['read']?? {},

        key: key
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'receiverUids':receiverUids,
      'senderUid':senderUid,

      'message':message,
      'timestamp':timestamp,
      'read':read
    };
  }
}
