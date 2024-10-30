import 'package:either_dart/either.dart';

import '../../../common/failures/failure.dart';
import '../entities/user_data_entity.dart';


abstract class UserDataRepository{
  Future<Either<Failure,UserData>> getUserByUid(String uid);
  Future<Either<Failure,List<UserData>>> getUsersByPrefix(String prefix,[List<String>? restricted,int? limit]);
  Future<Either<Failure,List<UserData>>> getFriends(List<String>? friends,int  limit,bool? refresh,List<String>? excluded,[String? prefix]);
  Future<void> setUserState({required String activeOrInactive});
}