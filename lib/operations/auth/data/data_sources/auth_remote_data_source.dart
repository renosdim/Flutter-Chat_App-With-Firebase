import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/domain/entities/user_data_entity.dart';
import 'package:either_dart/either.dart';

import '../../../common/failures/failure.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthUserModel?> get user;

  Future<AuthUserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
  Future<Either<Failure,UserData>> enableUserExperience();
  Stream<Either<Failure,UserData>> getUser(String? token);
  Stream<Map<String,dynamic>?> getStartingChats();
  Future<Either<Failure, bool>> checkUsernameExistence(String prefix);
}
