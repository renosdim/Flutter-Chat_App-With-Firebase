import 'package:equatable/equatable.dart';

import '../common/post_enums/post_participant_state_enum.dart';

abstract class UserDTO extends Equatable{
  final String username;
  final ParticipantState? state;
  final String name;
  final String profilePicture;
  final String uid;
  const UserDTO({required this.username, required this.uid, required this.name, required this.profilePicture, this.state});
  @override
  // TODO: implement props
  List<Object?> get props => [uid];

  UserDTO copyWith();
}