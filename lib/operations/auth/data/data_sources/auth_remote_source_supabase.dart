import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/models/auth_user_model.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/failures/failure.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/domain/entities/user_data_entity.dart';
import 'package:either_dart/src/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteSupa extends AuthRemoteDataSource{

  @override
  Future<Either<Failure, bool>> checkUsernameExistence(String prefix) {
    // TODO: implement checkUsernameExistence
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserData>> enableUserExperience() {
    // TODO: implement enableUserExperience
    throw UnimplementedError();
  }

  @override
  Stream<Map<String, dynamic>?> getStartingChats() {
    // TODO: implement getStartingChats
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, UserData>> getUser(String? token) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<AuthUserModel> signInWithEmailAndPassword({required String email, required String password}) async  {
    // TODO: implement signInWithEmailAndPassword
    AuthResponse authResponse = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password

    );
    if(authResponse.user!=null){
      return AuthUserModel(id: authResponse.user!.id,);
    }
    else{
      throw Exception('Sign in failed: The user is null after sign in.');
    }
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword({required String email, required String password}) {
    // TODO: implement signUpWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  // TODO: implement user
  Stream<AuthUserModel?> get user => Supabase.instance.client.auth.onAuthStateChange.map((authState) {

    if(authState.event==AuthChangeEvent.signedIn){
      return AuthUserModel(id: authState.session!.user.id);
    }
    else{
      return null;
    }
    
  });
  
}