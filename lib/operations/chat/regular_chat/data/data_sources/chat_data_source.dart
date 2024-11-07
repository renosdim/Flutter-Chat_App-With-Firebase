
import 'package:either_dart/either.dart';

import '../../../../auth/current_user.dart';
import '../../../../common/entities/chatroom_entity.dart';
import '../../../../common/failures/failure.dart';
import '../../../../common/successes/success.dart';
import '../models/group_chat_model.dart';

abstract class ChatDataSource {
  final CurrentUserOp currentUserOp;
  const ChatDataSource({required this.currentUserOp});
  Future<Either<Failure, ChatroomEntity>> getChatroomMessages(String chatroomId);
  Either<Failure, Stream<Either<Failure,ChatroomEntity>>> setUpChatSubscription(String chatroomId);
  Either<Failure, Stream<Either<Failure, GroupChatModel>>> setUpGroupChatListener(String chatroomId);
  Future<Either<Failure, Success>> sendMessage(String receiverUid, String message,{String? replyFor});
  Future<void> markGroupMessageAsRead(String messageKey,String chatroomId);
  Future<Either<Failure,Success>> sendGroupMessage(List<String> receiverUids, String message, String postId);
  Future<Either<Failure,GroupChatModel>> getGroupMessages(String chatroomId);

}