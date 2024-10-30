import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/entities/chatroom_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RegularChatroom extends Equatable implements ChatroomEntity{
  final String chatroomId;
  final List<dynamic> components;
  final String friendId;
  const RegularChatroom({required this.chatroomId,required this.components,required this.friendId});
  @override
  // TODO: implement props
  List<Object?> get props => [components];
}