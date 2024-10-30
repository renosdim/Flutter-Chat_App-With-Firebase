
import 'package:either_dart/either.dart';

import '../../../../auth/current_user.dart';
import '../../../../common/failures/failure.dart';
import '../../../../users/domain/entities/user_data_entity.dart';
import '../../../../users/domain/repositories/user_data_repository.dart';
import '../../dtos/chat_participant_dto.dart';

class FindFriendsToText{
  final UserDataRepository userDataRepository;
  final CurrentUserOp currentUserOp;
  const FindFriendsToText({required this.currentUserOp,required this.userDataRepository});

  Future<Either<Failure,List<ChatParticipantDTO>>> call(int limit,bool? refresh,List<String>? excluded,[String? prefix]) async{
    Either<Failure,List<UserData>> list = await userDataRepository.getFriends(currentUserOp.currentUser.friends,limit, refresh,excluded,prefix);
    print('friends to text ${currentUserOp.currentUser.friends}');
    if(list.isRight){
      return Right(list.right.map((e) => ChatParticipantDTO( uid: e.uid, name: e.name, profilePic: e.photoURL, username: e.username)).toList());
    }
    else{
      return Left(list.left);
    }
  }
}