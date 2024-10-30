



import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/dto.dart';
import 'package:equatable/equatable.dart';

import 'chat_participant_dto.dart';

class GroupChatroomDTO extends Equatable implements ChatroomDTO {
  final String chatroomId;
  final List<ChatParticipantDTO> participants;
  final List<dynamic> messages;
  final dynamic lastMessage;
  final String groupChatName;
  const GroupChatroomDTO({required this.chatroomId,required this.participants,required this.messages,required this.lastMessage,required this.groupChatName});

  @override
  // TODO: implement props
  List<Object?> get props => [chatroomId,participants,messages,lastMessage,groupChatName];
}