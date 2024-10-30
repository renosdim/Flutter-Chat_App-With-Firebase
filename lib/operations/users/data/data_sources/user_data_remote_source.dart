


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/data/data_sources/user_data_local_source.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


import '../../../auth/current_user.dart';
import '../../../common/failures/failure.dart';
import '../models/user_data_model.dart';


class UserDataRemoteSource{
  final UserDataLocalSource userDataLocalSource;
  final CurrentUserOp currentUserOp;
  const UserDataRemoteSource( {required this.userDataLocalSource,required this.currentUserOp});
  Future<Either<Failure,UserDataModel>> getUserByUid(String uid,[String? prefix]) async {

    try{

        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection(
            'users').doc(uid).get();




      if (snapshot.exists) {
        UserDataModel userDataModel = UserDataModel.fromDocument(snapshot);
        userDataLocalSource.saveUserToCache(userDataModel);

        return Right(userDataModel);
      }
      else{
        return Left(UserNotFoundFailure());
      }
    }
    catch(e){
      print('caugth error $e');
      userDataLocalSource.removeUserFromCache(uid);
      return Left(UserRetrievalFailure(message: e));
    }

  }
  Set<UserDataModel> _convertFromQuerySnapshotToUser(QuerySnapshot querySnapshot){
    Set<UserDataModel> users = {};
    print('query snapshot docs ${querySnapshot.docs}');
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs){
      if(documentSnapshot.exists){
        try{
          UserDataModel userDataModel = UserDataModel.fromDocument(documentSnapshot);
          users.add(userDataModel);
          userDataLocalSource.saveUserToCache(userDataModel);
        }
        catch(e){
          //
        }
      }
    }
    return users;
  }
  Future<List<UserDataModel>> getUsersByPrefix(String prefix,[List? restrictedList,bool? usernamePriority,int? limit]) async{
    String uid = currentUserOp.currentUser.uid;
      restrictedList?.remove(uid);
      Set<UserDataModel> foundUsers = {};
      late QuerySnapshot querySnapshotBasedOnUsername;
      late QuerySnapshot querySnapshotBasedOnName;
      try{
        if(restrictedList!=null){
          querySnapshotBasedOnUsername = await FirebaseFirestore.instance.collection('users')
              .where('uid',whereIn: restrictedList).where('username',isGreaterThanOrEqualTo: prefix).get();
          if(usernamePriority!=true){
            querySnapshotBasedOnName = await FirebaseFirestore.instance.collection('users').where('uid',whereIn: restrictedList).where('name',isGreaterThanOrEqualTo: prefix).get();
            foundUsers = {..._convertFromQuerySnapshotToUser(querySnapshotBasedOnName),..._convertFromQuerySnapshotToUser(querySnapshotBasedOnUsername)};
          }
          else{
            foundUsers = {..._convertFromQuerySnapshotToUser(querySnapshotBasedOnUsername)};
          }



        }
        else{
          dynamic query = limit==null? FirebaseFirestore.instance.collection('users')
              .where('username',isGreaterThanOrEqualTo: prefix):FirebaseFirestore.instance.collection('users')
              .where('username',isGreaterThanOrEqualTo: prefix).limit(limit);
          querySnapshotBasedOnUsername = await query.get();
          if(usernamePriority!=true){
            querySnapshotBasedOnName = await FirebaseFirestore.instance.collection('users').where('name',isGreaterThanOrEqualTo: prefix).get();
            foundUsers = {..._convertFromQuerySnapshotToUser(querySnapshotBasedOnName),..._convertFromQuerySnapshotToUser(querySnapshotBasedOnUsername)};
          }
          else{
            foundUsers = {..._convertFromQuerySnapshotToUser(querySnapshotBasedOnUsername)};
          }
        }
        return foundUsers.toList();
      }

      catch(e){
        print('errorrr $e');
        return const [];
      }


  }
  Future<Either<Failure,UserDataModel>> getCurrentUser() async{
    String? currentUid = FirebaseAuth.instance.currentUser?.uid;
    if(currentUid!=null){
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(currentUid).get();

      if(snapshot.exists){
        return Right(UserDataModel.fromDocument(snapshot));
      }
      else{
        return Left(CurrentUserAccountNotFoundFailure());
      }
    }
    else{
      return Left(NotAuthenticatedFailure());
    }

  }

  Future<List<UserDataModel>> getFriends(List<String >friendsToBeRetrieved) async {

    List<UserDataModel> friends = [];

      for (String friendId in friendsToBeRetrieved.toSet()){

        Either<Failure,UserDataModel> user = await getUserByUid(friendId);
        if(user.isRight){
          friends.add(user.right);
        }

      }
      print('friendsToBereturned $friends');
      return friends.toList();




  }
  Future<void> setUserState({required String activeOrInactive}) async{
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('latest_chats_list').child(FirebaseAuth.instance.currentUser!.uid);
    return await databaseReference.update({'state':activeOrInactive});
  }

}