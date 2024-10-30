import 'package:either_dart/either.dart';

import '../../../../common/failures/failure.dart';
import '../../../../common/successes/success.dart';
import '../repositories/invite_repository.dart';



class AcceptInvite{
  final InviteRepository inviteRepository;
  const AcceptInvite({required this.inviteRepository});
  Future<Either<Failure,Success>> call(
      {required String postId,required String receiverUid}) async{
    return await inviteRepository.acceptInvite(receiverUid, postId);
  }
}