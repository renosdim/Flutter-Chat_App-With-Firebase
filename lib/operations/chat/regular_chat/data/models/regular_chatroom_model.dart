import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/failures/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../../generalOp.dart';
import '../../domain/entities/chatroom_entity.dart';
import 'message_model.dart';

class RegularChatroomModel extends RegularChatroom{
  const RegularChatroomModel({required super.chatroomId, required super.components, required super.friendId});
  factory RegularChatroomModel.fromDataSnapshot(DataSnapshot dataSnapshot,String chatroomId){
    dynamic messages = dataSnapshot.value;
    try {
      print('messages $messages');
      List<dynamic> data = [];
      for (dynamic i in messages.keys.toList()) {
        if (messages[i]['invite'] != null) {

        }
        else {
          data.add(MessageModel.fromSnapshot(messages[i], i));
        }
      }
      data.sort(compare);
      List<String> chatroomParts = chatroomId.split('_');
      String friendId = FirebaseAuth.instance.currentUser?.uid ==
          chatroomParts[0] ? chatroomParts[1] : chatroomParts[0];
      return RegularChatroomModel(
          chatroomId: chatroomId, components: data, friendId: friendId);
    }
    catch(e){
      print('here nigga $e');
      rethrow;
    }
  }
}