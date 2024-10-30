import 'package:either_dart/either.dart';

import '../../../../common/failures/failure.dart';
import '../../../../common/successes/success.dart';
import '../repositories/group_chat_repository.dart';


class SendGroupMessage{
  final GroupChatRepository groupChatRepository;
  const SendGroupMessage({required this.groupChatRepository});
  Future<Either<Failure,Success>> call(List<String> receiverUids, String message, String postId) async {
    return await groupChatRepository.sendGroupMessage(receiverUids,  message, postId);
  }
}