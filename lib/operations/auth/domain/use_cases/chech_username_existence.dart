
import 'package:either_dart/either.dart';

import '../../../common/failures/failure.dart';
import '../repositories/auth_repository.dart';

class CheckUsernameExistenceUseCase{
  final AuthRepository authRepository;
  const CheckUsernameExistenceUseCase(this.authRepository);
  Future<Either<Failure,bool>> call(String prefix) async {
    return await authRepository.checkUsernameExistence(prefix);
  }
  // Future<bool> call(String prefix) async {
  //
  // }
}