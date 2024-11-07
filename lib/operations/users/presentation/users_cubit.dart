
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/current_user.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/failures/failure.dart';

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/domain/repositories/user_data_repository.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/domain/usecases/get_users_by_prefix_usecase.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/fetch_user_enum.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/users_state.dart';

import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/user_data_entity.dart';

class UserOpCubit extends Cubit<UserState>{
  final CurrentUserOp _currentUserOp;

  final GetUsersByPrefix _getUsersByPrefix;
  final UserDataRepository _userDataRepository;
  DateTime? lastTyped;
  List<UserData> _searchResults =[];
  UserOpCubit({required GetUsersByPrefix getUsersByPrefix,required CurrentUserOp currentUserOp,required UserDataRepository userDataRepository}):
        _currentUserOp=currentUserOp,_userDataRepository = userDataRepository,_getUsersByPrefix = getUsersByPrefix,super(const UserState());

  void getUsersByPrefix(String prefix,[List<String>? restricted]) async{
    lastTyped ??= DateTime.now();
    if(DateTime.now().difference(lastTyped!).inSeconds<1){
      print('damn');
      print(lastTyped!.difference(DateTime.now()).inSeconds);
    }
    else {
      lastTyped = DateTime.now();


      if(prefix.isEmpty){

      }
      else{
        _searchResults = _searchResults.where((e)=>e.username.contains(prefix)||e.name?.contains(prefix)==true).toList();

        if(_searchResults.isEmpty || _searchResults.length<5){
          emit(state.copyWith(fetchUserStatus: FetchUserStatus.loading));
          Either<Failure,List<UserData>> list = await _getUsersByPrefix(prefix: prefix,restricted:restricted,limit:3);
          if(list.isRight){
            _searchResults = _searchResults+list.right;
            emit(state.copyWith(fetchUserStatus: FetchUserStatus.successful,user: _searchResults));
          }
          else{
            if (list.left is InternetConnectionFailure) {
              emit(state.copyWith(
                  fetchUserStatus: FetchUserStatus.noInternetConnectionError));
            }
            else {
              emit(state.copyWith(fetchUserStatus: FetchUserStatus.successful,user: _searchResults));
            }
          }
        }
        else if(_searchResults.length>=5){
          emit(state.copyWith(fetchUserStatus: FetchUserStatus.successful,user: _searchResults));
        }
      }
    }
  }
  void getUserProfileById(String uid) async{
    emit(state.copyWith(fetchUserStatus: FetchUserStatus.loading));
    Either<Failure,UserData> getUser = await _userDataRepository.getUserByUid(uid);
    if(getUser.isRight){
      emit(state.copyWith(user: [getUser.right],fetchUserStatus: FetchUserStatus.successful));
    }
    else{
      print('error bitch');
      print(getUser.left.message);
      if(getUser.left is UserNotFoundFailure){
        emit(state.copyWith(fetchUserStatus: FetchUserStatus.notFoundError));
      }
      else if(getUser.left is InternetConnectionFailure){
        emit(state.copyWith(fetchUserStatus: FetchUserStatus.noInternetConnectionError));
      }
      else{
        emit(state.copyWith(fetchUserStatus: FetchUserStatus.unknownError));
      }
    }
  }
}