import 'package:either_dart/either.dart';

import '../../../../common/failures/failure.dart';
import '../../dtos/chat_dto_mapper.dart';
import '../../dtos/regular_chatroom_dto.dart';
import '../entities/chatroom_entity.dart';
import '../repositories/message_repository.dart';

class SetUpStartingChatListeners{

  final MessageRepository messageRepository;
  final ChatDTOMapper chatDTOMapper;
  SetUpStartingChatListeners({required this.messageRepository,required this.chatDTOMapper});
  Either<Failure, Stream<RegularChatroomDTO?>> call()  {
    Either<Failure,Stream<RegularChatroom?>> listener =  messageRepository.setUpStartingChatSubscriptions();
    if(listener.isRight){
      return Right(listener.right.asyncMap((event) =>event!=null? chatDTOMapper.fromEntityToDTO(event):null));
    }
    else{
      return Left(listener.left);
    }
  }
}