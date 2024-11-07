
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/add_user_enum.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/add_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserCubit extends Cubit<AddUserState>{
    AddUserCubit():super(const AddUserState());

    void addUser(String uid) async{
      print('add user');
      emit(state.copyWith(addUserStatus: AddUserStatus.loading));
      await Future.delayed(Duration(seconds: 1));
      emit(state.copyWith(addUserStatus: AddUserStatus.requestSent));

    }

}