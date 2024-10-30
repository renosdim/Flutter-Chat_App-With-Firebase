import 'package:firebase_database/firebase_database.dart';



import '../../../../generalOp.dart';
import '../../domain/entities/group_chatroom_entity.dart';
import 'group_message_model.dart';

class GroupChatModel extends GroupChatroom{
  GroupChatModel({required super.chatroomId, required super.lastMessage, required super.participants,  super.groupChatName, required super.messages});

  factory GroupChatModel.fromDataSnapshot(DataSnapshot dataSnapshot,String chatroomId){
    dynamic snapshot = dataSnapshot.value as dynamic;
    dynamic messagesSnapshot = snapshot['messages'];
    print('before op $chatroomId');
    List<dynamic> messages = [];
    try {
      for (dynamic i in messagesSnapshot.keys.toList()) {
        try {
          if (messagesSnapshot[i]['data'] == null) {
            messages.add(
                GroupMessageModel.fromSnapshot(messagesSnapshot[i], i));
          }
        }
        catch (e) {
          print('error1 with groupchat $chatroomId   $e');
        }
      }
    }
      catch(e){
        print('error2 with groupchat $chatroomId   $e');
      }



    messages.sort(compare);
    //messages = messages.reversed.toList();

    print('in groupchat $chatroomId');
    List? groupParticipants = snapshot['groupParticipants']?.keys.toList() as List?;
    print(groupParticipants);
    return GroupChatModel(chatroomId: chatroomId,
        messages:messages,
        lastMessage: messages.isNotEmpty?messages.last:null,
        participants: groupParticipants?.whereType<String>().toList() ??[],
        groupChatName: snapshot['groupName'],);
  }
}