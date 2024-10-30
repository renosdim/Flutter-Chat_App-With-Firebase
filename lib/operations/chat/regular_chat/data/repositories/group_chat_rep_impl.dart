import 'package:either_dart/either.dart';

import '../../../../common/failures/failure.dart';
import '../../../../common/network_info.dart';
import '../../../../common/successes/success.dart';
import '../data_sources/common_chat_data_source.dart';
import '../../domain/entities/group_chatroom_entity.dart';
import '../../domain/repositories/group_chat_repository.dart';



class GroupChatRepImpl implements GroupChatRepository{
  final MessageRemoteSource groupChatRemoteSource;
  final NetworkInfo networkInfo;
  const GroupChatRepImpl({required this.groupChatRemoteSource,required this.networkInfo});
  @override
  Future<void> markAsRead(String key,String chatroomId) async{
    // TODO: implement markAsRead
    return await groupChatRemoteSource.markGroupMessageAsRead(key, chatroomId);
  }

  @override
  Future<Either<Failure, Success>> sendGroupMessage(List<String> receiverUids, String message, String postId) async {
    // TODO: implement sendGroupMessage
    return await groupChatRemoteSource.sendGroupMessage(receiverUids, message, postId);
  }

  @override
  Either<Failure, Stream<GroupChatroom?>> setUpGroupChatListener(String chatroomId)  {
    // TODO: implement setUpGroupChatListener
   throw UnimplementedError();
  }

  @override
  Future<Either<Failure, GroupChatroom?>> getGroupMessages(String chatroomId) async {
    // TODO: implement getChatroom
    if(networkInfo.hasConnection){
      return await groupChatRemoteSource.getGroupMessages(chatroomId);
    }
    else{
      return Left(InternetConnectionFailure());
    }
  }

}