
import 'package:either_dart/either.dart';

import '../../../common/entities/saved_object_entity.dart';
import '../../../common/failures/failure.dart';
import '../models/user_data_model.dart';

class UserDataLocalSource{

  Map<String,SavedObject<UserDataModel>> _loadedUsers = {};
  Either<Failure,UserDataModel> getUserByUid(String uid){
    SavedObject? user = _loadedUsers[uid];
    if(user!=null && user.isCurrent(const Duration(hours: 1))){
      print('user $uid found');
      return Right(user.object);
    }
    else{
      print('user $uid not found');
      return Left(UserNotFoundFailure());
    }
  }
  void saveUserToCache(UserDataModel userDataModel){
    _loadedUsers[userDataModel.uid] = SavedObject<UserDataModel>(timestamp: DateTime.now(), object: userDataModel);
    print('added friend to cache ${userDataModel.uid}');
  }
  void removeUserFromCache(String uid){
    _loadedUsers.remove(uid);
  }
  List<UserDataModel> getFriends(List<String>? excluded,[String? prefix]){
    List<UserDataModel> friends = [];
    print('loaded users $_loadedUsers');
    for (SavedObject<UserDataModel>user in _loadedUsers.values){

      if(user.isCurrent(const Duration(seconds:10))){

        if(excluded?.contains(user.object.uid)!=true){
          if(prefix==null){
            friends.add(user.object);
          }
          else{
            if(user.object.name?.contains(prefix)==true && user.object.username.contains(prefix)){
             friends.add(user.object);
            }
          }

        }

      }


    }
    return friends;
  }
}