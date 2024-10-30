
import 'package:either_dart/either.dart';

import '../../../../common/failures/failure.dart';
import '../../../../common/successes/success.dart';
import '../entities/group_chatroom_entity.dart';




abstract class GroupChatRepository{
  Future<Either<Failure,Success>> sendGroupMessage(List<String> receiverUids, String message, String postId);
  Future<void> markAsRead(String key,String chatroomId);
  Either<Failure,Stream<GroupChatroom?>> setUpGroupChatListener(String chatroomId);
  Future<Either<Failure,GroupChatroom?>> getGroupMessages(String chatroomId);

}