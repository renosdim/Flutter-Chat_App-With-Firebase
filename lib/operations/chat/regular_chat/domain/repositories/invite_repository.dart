import 'package:either_dart/either.dart';

import '../../../../common/failures/failure.dart';
import '../../../../common/successes/success.dart';

abstract class InviteRepository{
  Future<Either<Failure,Success>> acceptInvite(String receiverUid,String postId);
  Future<Either<Failure,Success>> rejectInvite(String receiverUid,String postId);
}