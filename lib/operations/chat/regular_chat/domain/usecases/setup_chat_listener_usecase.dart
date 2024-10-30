import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/domain/entities/group_chatroom_entity.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/entities/chatroom_entity.dart';
import 'package:either_dart/either.dart';
import '../../../../common/dto.dart';
import '../../../../common/failures/failure.dart';
import '../../dtos/chat_dto_mapper.dart';
import '../entities/chatroom_entity.dart';
import '../repositories/message_repository.dart';

class SetUpChatListener {
  final MessageRepository messageRepository;
  final ChatDTOMapper chatDTOMapper;

  SetUpChatListener(
      {required this.messageRepository, required this.chatDTOMapper});

  Either<Failure, Stream<Either<Failure,ChatroomDTO>>> call(String chatroomId) {
    Either<Failure, Stream<Either<Failure,ChatroomEntity>>> listener = messageRepository
        .setUpChatSubscription(chatroomId);
    try {
      if (listener.isRight) {
        return Right(listener.right.asyncMap(

                (event) async {
                  if(event.isRight) {
                    ChatroomEntity chatroomEntity = event.right;
                    if (chatroomEntity is RegularChatroom) {
                      return Right(await chatDTOMapper.fromEntityToDTO(chatroomEntity));
                    }
                    else {
                      return Right(await chatDTOMapper.fromGroupChatEntityToDTO(
                          chatroomEntity as GroupChatroom));
                    }
                  }
                  else{
                    return Left(event.left);
                  }
            }));
      }
      else {
        return Left(listener.left);
      }
    }
    catch(e){
      return Left(UnexpectedError(message: e));
    }
  }


}