
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/src/either.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../common/failures/failure.dart';
import '../../../users/data/models/user_data_model.dart';
import '../../../users/domain/entities/user_data_entity.dart';
import '../models/auth_user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceFirebase implements AuthRemoteDataSource {
  AuthRemoteDataSourceFirebase({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  late UserData currentUser;
  late StreamSubscription<Either<Failure,UserData>>? streamSubscription;
  Map<String, dynamic>? existingChats;
  @override
  Stream<AuthUserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      print('firebase user ${firebaseUser}');
      if (firebaseUser == null) {
        return null;
      }
      return AuthUserModel.fromFirebaseAuthUser(firebaseUser);
    });
  }

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign up failed: The user is null after sign up.');
      }

      return AuthUserModel.fromFirebaseAuthUser(credential.user!);
    } catch (error) {
      throw Exception('Sign up failed: $error');
    }
  }



  @override
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign in failed: The user is null after sign in.');
      }

      return AuthUserModel.fromFirebaseAuthUser(credential.user!);
    } catch (error) {
      throw Exception('Sign in failed: $error');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      print('sign out');
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }

  @override
  Future<Either<Failure, bool>> checkUsernameExistence(String prefix) async {
    // TODO: implement checkUsernameExistence
    try{
      QuerySnapshot querySnapshot  = await FirebaseFirestore.instance.collection('users').where('username',isEqualTo: prefix).get();
      if(querySnapshot.docs.isNotEmpty){
        if(querySnapshot.docs[0].exists){
          print(querySnapshot.docs[0].data());
        }
        return const Right(false);
      }
      else{
        return const  Right(true);
      }
    }
    catch (e){
      return Left(UnexpectedError(message: e));
    }

  }
  @override
  Stream<Either<Failure,UserData>> getUser(String? token){
      try{



        return FirebaseFirestore.instance.collection('users').doc(_firebaseAuth.currentUser!.uid)
            .snapshots().map((event) {
                try{
                    Either<Failure,UserData> user = event.exists?Right(UserDataModel.fromDocument(event,token)):
                    Left(CurrentUserAccountNotFoundFailure());
                    // if(user.isRight){
                    //   currentUser = user.right;}
                    return user;
                    }
                catch(e){
                print('re vlaka');
                return Left(UserRetrievalFailure(message: e));
                }

      });
      }
      catch(e){

      return Stream.value(Left(NotAuthenticatedFailure()));
      }

  }
  @override
  Stream<Map<String,dynamic>?> getStartingChats(){
  return FirebaseDatabase.instance.ref().child('latest_chats_list').child(_firebaseAuth.currentUser!.uid).onValue.map((event)  {

  Map<String,dynamic>? existingChats = Map<String, dynamic>.from(event.snapshot.value as Map);
  existingChats = Map<String, dynamic>.from(existingChats['chatrooms']??{} as
  Map);
  return existingChats;
  }
  );
  }

  @override
  Future<Either<Failure, UserData>> enableUserExperience() async  {
    // TODO: implement enableUserExperience
    if(_firebaseAuth.currentUser!=null){

      String? token = await FirebaseMessaging.instance.getToken();
      DocumentReference ref =  FirebaseFirestore.instance.collection('users').doc(_firebaseAuth.currentUser!.uid);
      DocumentSnapshot snapshot = await ref.get();


      if((snapshot.data() as Map<String,dynamic>)['registeredDevices']==null){

        await ref.update({
          'registeredDevices':FieldValue.arrayUnion([token])
        });

      }
      else if(!(snapshot.data() as Map<String,dynamic>)['registeredDevices'].contains(token)){
        List<dynamic> registeredDevices  = (snapshot.data() as Map<String,dynamic>)['registeredDevices'];
        registeredDevices.add(token!);
        await ref.update({
          'registeredDevices':FieldValue.arrayUnion(registeredDevices)
        });
      }
      return Right(UserDataModel.fromDocument(snapshot,token));






  }
    else{
      return Left(UserRetrievalFailure(message: 'not logged in '));
    }
  }
}
