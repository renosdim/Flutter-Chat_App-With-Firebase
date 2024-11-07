
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/fetch_user_enum.dart';
import 'package:equatable/equatable.dart';

import '../domain/entities/user_data_entity.dart';
import 'add_user_enum.dart';
class UserState extends Equatable {
  final FetchUserStatus fetchUserStatus;

  final List<UserData>? user;

  const UserState( {

    this.fetchUserStatus = FetchUserStatus.unknown,
    this.user,
  });

  // CopyWith function to create a new instance with modified properties
  UserState copyWith({
    FetchUserStatus? fetchUserStatus,
    List<UserData>? user,

  }) {
    return UserState(

      fetchUserStatus: fetchUserStatus ?? this.fetchUserStatus,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [fetchUserStatus, user];
}