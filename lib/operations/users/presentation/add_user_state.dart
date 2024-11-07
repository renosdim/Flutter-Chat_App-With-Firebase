import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/add_user_enum.dart';
import 'package:equatable/equatable.dart';

class AddUserState extends Equatable{
  final AddUserStatus addUserStatus;
  const AddUserState({this.addUserStatus=AddUserStatus.unknown});

  @override
  // TODO: implement props
  List<Object?> get props =>[addUserStatus];

  AddUserState copyWith({AddUserStatus? addUserStatus}){
    return AddUserState(
      addUserStatus: addUserStatus??this.addUserStatus
    );
  }
}