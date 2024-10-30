import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/entities/chatroom_entity.dart';

abstract class GroupChatroom implements ChatroomEntity{
  final String chatroomId;
  final List<dynamic> messages;
  final dynamic lastMessage;
  final List<String> participants;
  final String? groupChatName;

  const GroupChatroom({required this.chatroomId,required this.messages,required this.lastMessage,required this.participants, this.groupChatName});
}