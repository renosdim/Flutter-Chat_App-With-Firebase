import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/domain/entities/group_chatroom_entity.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/entities/chatroom_entity.dart';
import 'package:either_dart/either.dart';
import '../../../../common/dto.dart';
import '../../../../common/failures/failure.dart';
import '../../dtos/chat_dto_mapper.dart';
import '../entities/chatroom_entity.dart';
import '../repositories/message_repository.dart';


class GetStartingMessages {
  final MessageRepository messageRepository;
  final ChatDTOMapper chatDTOMapper;

  GetStartingMessages(this.messageRepository, this.chatDTOMapper);

  Future<Either<Failure, ChatroomDTO?>> call(String chatroomId) async {
    Either<Failure, ChatroomEntity?> chat = await messageRepository
        .getChatroomMessages(chatroomId);
    try {
      if (chat.isRight) {
        if (chat.right != null) {
          if(chat.right is RegularChatroom){
            return Right(await chatDTOMapper.fromEntityToDTO(chat.right! as RegularChatroom));
          }
          else{
            return Right(await chatDTOMapper.fromGroupChatEntityToDTO(chat.right! as GroupChatroom));
          }
          print('right got em');

        }
        else {
          return Left(UnexpectedError(message: 'd'));
        }
      }
      else {
        print('left ${chat.left.message}');
        return Left(chat.left);
      }
    }

    catch (e) {
      return Left(UnexpectedError(message: 'e'));
    }
  }
}