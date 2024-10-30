


import 'package:either_dart/either.dart';

import '../../../../common/failures/failure.dart';
import '../../dtos/chat_dto_mapper.dart';
import '../../dtos/group_chatroom_dto.dart';
import '../entities/group_chatroom_entity.dart';
import '../repositories/group_chat_repository.dart';

class GetGroupMessages{
  final GroupChatRepository groupChatRepository;
  final ChatDTOMapper chatDTOMapper;
  const GetGroupMessages({required this.groupChatRepository,required this.chatDTOMapper});
  Future<Either<Failure,GroupChatroomDTO?>> call(String chatroomId) async{
    Either<Failure,GroupChatroom?> chat =  await groupChatRepository.getGroupMessages(chatroomId);
    if(chat.isRight){
      if(chat.right!=null){
        return  Right( await chatDTOMapper.fromGroupChatEntityToDTO(chat.right!));
      }
      else{
        return const Right(null);
      }
    }
    else{
      return Left(chat.left);
    }
  }
}