

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/dto.dart';
import 'package:equatable/equatable.dart';

import 'chat_participant_dto.dart';

class RegularChatroomDTO extends Equatable implements ChatroomDTO{
  final List<dynamic> chatroomComponents;
  final ChatParticipantDTO chatParticipant;
  final String chatroomId;
  const RegularChatroomDTO({required this.chatroomComponents,required this.chatParticipant,required this.chatroomId});

  @override
  // TODO: implement props
  List<Object?> get props =>[chatroomComponents,chatParticipant,chatroomId];
}