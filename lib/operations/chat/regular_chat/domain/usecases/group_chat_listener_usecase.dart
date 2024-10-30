import 'package:either_dart/either.dart';

import '../../../../common/failures/failure.dart';
import '../../dtos/chat_dto_mapper.dart';
import '../../dtos/group_chatroom_dto.dart';
import '../entities/group_chatroom_entity.dart';
import '../repositories/group_chat_repository.dart';


class SetUpGroupChatListener{
 final GroupChatRepository groupChatRepository;
 final ChatDTOMapper chatDTOMapper;
 const SetUpGroupChatListener({required this.groupChatRepository,required this.chatDTOMapper});

 Either<Failure,Stream<GroupChatroomDTO?>> call(String chatroomId){
   Either<Failure,Stream<GroupChatroom?>> stream = groupChatRepository.setUpGroupChatListener(chatroomId);
   if(stream.isRight){
     print('right for $chatroomId');
     return Right(stream.right.asyncMap((event) => event!=null?chatDTOMapper.fromGroupChatEntityToDTO(event):null));
   }
   else{
     return Left(stream.left);
   }

 }

}