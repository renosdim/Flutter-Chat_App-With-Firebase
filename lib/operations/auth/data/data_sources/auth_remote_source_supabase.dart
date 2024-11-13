import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/models/auth_user_model.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/failures/failure.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/domain/entities/user_data_entity.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  Future<AuthUserModel> googleSignIn() async {
      print('google sign in');
      /// TODO: update the Web client ID with your own.
      ///
      /// Web Client ID that you registered with Google Cloud.
      const webClientId =  '916180170981-ouc80bti4thepo8cv60sp2sfr1ll9l8o.apps.googleusercontent.com';

      /// TODO: update the iOS client ID with your own.
      ///
      /// iOS Client ID that you registered with Google Cloud.
      //const iosClientId = 'my-ios.apps.googleusercontent.com';

      // Google sign in on Android will work without providing the Android
      // Client ID registered on Google Cloud.
      if(kIsWeb){
        bool authResponse = await Supabase.instance.client.auth.signInWithOAuth(
            OAuthProvider.google,
            // Optionally set the redirect link to bring back the user via deeplink.
             // Launch the auth screen in a new webview on mobile.
          );
          throw true; 
      }
      
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: webClientId,
        
        
      );
      final googleUser = await googleSignIn.signIn();
      print('google User ${googleUser}');
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        print('no access token');
        throw Exception('No Access Token found.');
      }
      if (idToken == null) {
        print('no id token');
        throw Exception('No ID Token found.');
      }
      print('authResponse');
      AuthResponse authResponse = await  Supabase.instance.client.auth.signInWithIdToken(
        
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
        
      );
      if(authResponse.user!=null){
        print('auth user model');
        return AuthUserModel(id:authResponse.user!.id);
      }
      print('not found');
      throw Exception('Not found');
    }
    

  @override
  Future<void> signOut() async  {
    // TODO: implement signOut
    await Supabase.instance.client.auth.signOut();
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