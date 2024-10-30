import 'dart:async';

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/entities/chatroom_entity.dart';
import 'package:either_dart/either.dart';

import '../../../../common/failures/failure.dart';
import '../../../../common/network_info.dart';
import '../../../../common/successes/success.dart';
import '../data_sources/common_chat_data_source.dart';
import '../../domain/entities/chatroom_entity.dart';
import '../../domain/repositories/message_repository.dart';

class MessageRepImp implements MessageRepository{
  final MessageRemoteSource messageRemoteSource;
  final NetworkInfo networkInfo;
  MessageRepImp(this.messageRemoteSource,this.networkInfo);
  @override
  Future<Either<Failure,ChatroomEntity>> getChatroomMessages(String chatroomId) async  {
      if(networkInfo.hasConnection){
        return await messageRemoteSource.getChatroomMessages(chatroomId);
      }
      else{
        return Left(InternetConnectionFailure());
      }



  }

  @override
  Future<Either<Failure, Success>> sendMessage(String receiverUid,String message,{String? replyFor}) async {
    if(networkInfo.hasConnection){
      return await messageRemoteSource.sendMessage(receiverUid,message,replyFor: replyFor);
    }
    else{
      return Left(InternetConnectionFailure());
    }

  }

  @override
  Either<Failure, Stream<Either<Failure,ChatroomEntity>>> setUpChatSubscription(String chatroomId)  {
    // TODO: implement setUpChatSubscription
    return messageRemoteSource.setUpChatSubscription(chatroomId);
  }

  @override
  Either<Failure, Stream<RegularChatroom?>> setUpStartingChatSubscriptions() {
    // TODO: implement setUpStartingChatSubscriptions
    return messageRemoteSource.setUpStartingChatSubscriptions();
  }

}