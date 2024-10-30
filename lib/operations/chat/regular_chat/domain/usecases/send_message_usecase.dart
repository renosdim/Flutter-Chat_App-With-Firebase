import 'package:either_dart/either.dart';
import '../../../../common/failures/failure.dart';
import '../../../../common/successes/success.dart';
import '../repositories/message_repository.dart';


class SendMessage{
  final MessageRepository messageRepository;
  SendMessage(this.messageRepository);

  Future<Either<Failure, Success>> call(String receiverUid,String message,{String? replyFor}) async  {
    // TODO: implement call
    return await messageRepository.sendMessage(receiverUid,message,replyFor: replyFor);
  }

}