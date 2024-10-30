

import 'package:either_dart/src/either.dart';

import '../../../common/failures/failure.dart';
import '../../../common/network_info.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;


  const AuthRepositoryImpl(this.networkInfo, {
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<AuthUser> get authUser {
    return remoteDataSource.user.map((authUserModel) {
      if (authUserModel != null) {
        localDataSource.write(key: 'user', value: authUserModel);
      } else {
        localDataSource.write(key: 'user', value: null);
      }

      return authUserModel == null ? AuthUser.empty : authUserModel.toEntity();
    });
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    final authModel = await remoteDataSource.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );

    localDataSource.write(key: 'user', value: authModel);

    return authModel.toEntity();
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final authModel = await remoteDataSource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    localDataSource.write(key: 'user', value: authModel);

    return authModel.toEntity();
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();

    localDataSource.write(key: 'user', value: null);
  }

  @override
  Future<Either<Failure, bool>> checkUsernameExistence(String prefix) async {
    // TODO: implement checkUsernameExistence
    if(networkInfo.hasConnection){
      return await remoteDataSource.checkUsernameExistence(prefix);
    }
    else{
      return Left(InternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> enableUser() {
    // TODO: implement enableUser
    throw UnimplementedError();
  }
}
