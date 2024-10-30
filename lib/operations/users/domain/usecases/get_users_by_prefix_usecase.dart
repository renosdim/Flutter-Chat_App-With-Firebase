
import 'package:either_dart/src/either.dart';

import '../../../common/failures/failure.dart';
import '../entities/user_data_entity.dart';
import '../repositories/user_data_repository.dart';



class GetUsersByPrefix {
  final UserDataRepository userDataRepository;
  const GetUsersByPrefix(this.userDataRepository);

  Future<Either<Failure, List<UserData>>> call({required String prefix, List<String>? restricted,int? limit}) async {
    // TODO: implement call
    return await userDataRepository.getUsersByPrefix(prefix,restricted,limit);
  }

}