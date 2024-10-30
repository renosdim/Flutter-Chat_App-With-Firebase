
import 'package:either_dart/either.dart';

import '../../../common/failures/failure.dart';
import '../../../common/network_info.dart';
import '../../domain/entities/user_data_entity.dart';
import '../../domain/repositories/user_data_repository.dart';
import '../data_sources/user_data_local_source.dart';
import '../data_sources/user_data_remote_source.dart';

class UserDataRepImpl implements UserDataRepository{
  final UserDataRemoteSource remoteSource;
  final UserDataLocalSource localSource;
  final NetworkInfo networkInfo;

  const UserDataRepImpl( {required this.remoteSource,required this.networkInfo,required this.localSource});
  @override
  Future<Either<Failure, UserData>> getUserByUid(String uid,[bool? refresh]) async  {
    // TODO: implement getUserByUid
    if(refresh==true){
      if(networkInfo.hasConnection){
        return await remoteSource.getUserByUid(uid);
      }
      else{
        return localSource.getUserByUid(uid);
      }
    }
    else{
      Either<Failure,UserData> foundUserInCache = localSource.getUserByUid(uid);
      if(foundUserInCache.isRight){
        return Right(foundUserInCache.right);
      }
      else{
        return await remoteSource.getUserByUid(uid);
      }
    }
  }

  @override
  Future<Either<Failure, List<UserData>>> getUsersByPrefix(String prefix,[List<String>? restricted,int? limit]) async {
    // TODO: implement getUserByPrefix
    return Right(await remoteSource.getUsersByPrefix(prefix,restricted,true,limit));
  }


  List<T> _elementsNotInOtherList<T>(List<T> list1, List<T>? list2) {
    if(list2!=null){
      return list1.where((element) => !list2.contains(element)).toList();
    }
    return list1;

  }
  @override
  Future<Either<Failure, List<UserData>>> getFriends(List<String>? friends,int limit,bool? refresh,[List<String>? excluded,String? prefix]) async {
    // TODO: implement getFriends
    Set<UserData> cachedWithExcluded = localSource.getFriends(excluded,prefix).toSet();
    List<String> cachedWithoutExcluded = _elementsNotInOtherList(cachedWithExcluded.map((e) => e.uid).toList(), excluded);
    List<String > cachedAndExcludedUsers = [...?excluded,...cachedWithoutExcluded];
    List<String> friendsToBeRetrieved = _elementsNotInOtherList(friends??[], cachedAndExcludedUsers);
    friendsToBeRetrieved = friendsToBeRetrieved.length>=limit?
    friendsToBeRetrieved.sublist(0,limit):friendsToBeRetrieved;
    Set<UserData> friendsFromCache = {...cachedWithExcluded.where((element) => cachedWithExcluded.contains(element))};
      if(networkInfo.hasConnection){
        if(refresh==true){
          if(prefix==null){
            List<UserData> friendsFromRemote = await remoteSource.getFriends(friendsToBeRetrieved);

            return Right([...friendsFromRemote,...friendsFromCache.toList()]);
          }
          else{
            return Right(await remoteSource.getUsersByPrefix(prefix,friendsToBeRetrieved));
          }

        }
        else{


         if(friendsFromCache.length<limit){
           if(prefix==null){
             List<UserData> friendsFromRemote = await remoteSource.getFriends(friendsToBeRetrieved);

             return Right(friendsFromRemote+friendsFromCache.toList());
           }
           else{
             List<UserData> friendsFromRemote = await remoteSource.getUsersByPrefix(prefix,friendsToBeRetrieved);

             return Right(friendsFromRemote+friendsFromCache.toList());
           }

          }
         else{
           return Right(friendsFromCache.toList());
         }
        }
      }
      else{
        return Right(friendsFromCache.toList());
      }


  }

  @override
  Future<void> setUserState({required String activeOrInactive}) async  {
    // TODO: implement setUserState
    return await remoteSource.setUserState(activeOrInactive:activeOrInactive);
  }


}