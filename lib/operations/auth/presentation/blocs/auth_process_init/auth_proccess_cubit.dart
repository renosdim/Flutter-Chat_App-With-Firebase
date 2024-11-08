
import 'dart:async';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/current_user.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/models/auth_user_model.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/presentation/blocs/auth_process_init/auth_proccess_state.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/failures/failure.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/domain/entities/user_data_entity.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../chat/regular_chat/presentation/ChatService.dart';
import '../../../data/data_sources/auth_remote_data_source.dart';




class AuthInitializeProcessesCubit extends Cubit<AuthProcessState>{
  final ChatService _chatService;
  final SignOutUseCase _signOutUseCase;
  final CurrentUserOp _currentUserOp;
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthInitializeProcessesCubit({required AuthRemoteDataSource authRemoteDataSource,required CurrentUserOp currentUserOp,required ChatService chatService,required SignOutUseCase signOutUseCase}):
        _chatService=chatService,
        _signOutUseCase=signOutUseCase,
        _currentUserOp = currentUserOp,
        _authRemoteDataSource = authRemoteDataSource,
        super(const AuthProcessState(loadingDependencies: true));
  late StreamSubscription<AuthUserModel?> authSubscription;
  late StreamSubscription<Either<Failure,UserData>> userDataSub;
  bool loggedIn=false;
  Future<void> enable() async {
    emit(state.copyWith(loadingDependencies: true));
    authSubscription = _authRemoteDataSource.user.listen((user) async {
      if (user != null) {
        print('yes');
        emit(state.copyWith(
            loggedIn: true, loadingDependencies: true));
        // await _enableUser();
        // bool result = await _chatService.enable();
        // while (result==false){
        //   result = await _chatService.enable();
        // }
        loggedIn = true;
        emit(state.copyWith(loggedIn: true, loadingDependencies: false));
      }
      else {
        print('logged out');
        _cleanUp();
        //_cleanUp();
      }
    });
  }

  Future<void> _enableUser() async {
    Either<Failure, UserData> userEnable = await _authRemoteDataSource
        .enableUserExperience();

    if (userEnable.isRight) {
      _currentUserOp.updateUser(userEnable.right,runtimeType);

      userDataSub = _authRemoteDataSource.getUser(_currentUserOp.currentUser.currentRegToken).listen((
          event) {
        if (event.isRight) {
          _currentUserOp.updateUser(event.right,runtimeType);
        }
        else {
            _cleanUp();
        }
      });
    }
    else {

    }
  }

  Future<void> _cleanUp() async  {
    try {
      userDataSub.cancel();
    }
    catch(_){

    }
    emit(state.copyWith(unloadingDependencies: true));
    _chatService.logoutCleanup();
    if(loggedIn==true){
      await _signOutUseCase();
      loggedIn = false;
    }

    emit(state.copyWith(loggedIn: false));
}





  }



