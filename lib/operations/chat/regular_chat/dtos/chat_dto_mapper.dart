import 'package:either_dart/either.dart';

import '../../../common/failures/failure.dart';
import '../../../users/domain/entities/user_data_entity.dart';
import '../../../users/domain/repositories/user_data_repository.dart';
import '../domain/entities/group_chatroom_entity.dart';
import 'group_chatroom_dto.dart';
import '../domain/entities/chatroom_entity.dart';
import 'chat_participant_dto.dart';
import 'regular_chatroom_dto.dart';

class ChatDTOMapper{
  final UserDataRepository userDataRepository;
  ChatDTOMapper({required this.userDataRepository});
  Future<RegularChatroomDTO> fromEntityToDTO(RegularChatroom chatroom) async{
    Either<Failure,UserData> getUser = await userDataRepository.getUserByUid(chatroom.friendId);

    if(getUser.isRight){
      print('NAME OF PARTICIPANT');
      print(getUser.right.name);
      return RegularChatroomDTO(chatroomComponents: chatroom.components,chatroomId: chatroom.chatroomId,
          chatParticipant:ChatParticipantDTO(username:getUser.right.username,uid: getUser.right.uid, name: getUser.right.name, profilePic: getUser.right.photoURL)
      );
    }
    else{
      throw Exception();
    }
    // else{
    //   return ChatroomDTO(chatroomComponents: chatroom.components,chatParticipant: ChatParticipantDTO(uid:chatroom.friendId,name: null,profilePic: null), chatroomId: chatroom.chatroomId
    //   );
    //}
  }

  Future<GroupChatroomDTO> fromGroupChatEntityToDTO(GroupChatroom chatroom) async{
    List<ChatParticipantDTO> groupParticipants = [];
    print('we r here with $chatroom');
    for(String friendId in chatroom.participants){
      Either<Failure,UserData> getUser = await userDataRepository.getUserByUid(friendId);
      if(getUser.isRight){
        groupParticipants.add(ChatParticipantDTO(username:getUser.right.username,uid: getUser.right.uid, name: getUser.right.name, profilePic: getUser.right.photoURL));
      }

    }
    return GroupChatroomDTO(chatroomId: chatroom.chatroomId,
        participants: groupParticipants,
        messages: chatroom.messages, lastMessage: chatroom.lastMessage, groupChatName: chatroom.groupChatName??'${groupParticipants[0].name},${groupParticipants[1].name}');
  }
}