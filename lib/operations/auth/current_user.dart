import 'dart:async';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/presentation/blocs/auth_process_init/auth_proccess_cubit.dart';
import 'package:either_dart/either.dart';
import 'package:rxdart/rxdart.dart';

import '../common/failures/failure.dart';
import '../users/domain/entities/user_data_entity.dart';
enum Loading{
  loading;
}
class CurrentUserOp {

  late final StreamSubscription<Either<Failure, UserData>> sub;
  final _userController = BehaviorSubject<Either<Failure,Either<Loading,UserData>>>();
  late UserData _currentUser;
  final AuthRemoteDataSource _authRemoteDataSource;

  CurrentUserOp({required AuthRemoteDataSource authRemoteDataSource}):_authRemoteDataSource = authRemoteDataSource;
  Map<String, dynamic>? existingChats;
  Map<String,List<String>> unloadedUsers = {};
  Stream<Either<Failure,Either<Loading,UserData>>> get userStream => _userController.stream;

  UserData get currentUser=>_currentUser;
  Stream<Map<String,dynamic>?> getStartingChats(){
    return _authRemoteDataSource.getStartingChats();
  }
  void updateUser(UserData user,Type classAccess){
    if(classAccess==AuthInitializeProcessesCubit){
      _currentUser = user;


    }
    else{
      throw Exception('You cant access that function without autorization');
    }

  }



  }




