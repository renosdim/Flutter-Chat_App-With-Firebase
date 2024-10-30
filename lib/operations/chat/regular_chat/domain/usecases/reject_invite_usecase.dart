import 'package:either_dart/either.dart';

import '../../../../common/failures/failure.dart';
import '../../../../common/successes/success.dart';
import '../repositories/invite_repository.dart';

class RejectInvite{
  final InviteRepository inviteRepository;
  const RejectInvite({required this.inviteRepository});
  Future<Either<Failure,Success>> call(String postId,String receiverUid) async{
    return await inviteRepository.rejectInvite(receiverUid, postId);
  }
}