import 'dart:async';

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/entities/chatroom_entity.dart';
import 'package:either_dart/either.dart';


import '../../../../common/failures/failure.dart';
import '../../../../common/successes/success.dart';
import '../entities/chatroom_entity.dart';

abstract class MessageRepository{
  Future<Either<Failure,Success>> sendMessage(String receiverUid,String message,{String? replyFor});
  Future<Either<Failure,ChatroomEntity>> getChatroomMessages(String chatroomId);
  Either<Failure,Stream<Either<Failure,ChatroomEntity>>> setUpChatSubscription(String chatroomId);
  Either<Failure,Stream<RegularChatroom?>> setUpStartingChatSubscriptions();
}