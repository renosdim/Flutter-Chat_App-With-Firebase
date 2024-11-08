
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/users/immut/search_users_by_prefix_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
class GeneralNavigationState extends Equatable{
  final Widget starter;
  final String? openedChatroomWithId;
  final String? showUserProfileWithId;
  final bool? leaveChatroom;
  final bool? loadingUser;
  final bool? showPersonalProfile;
  final bool? showChats;
  const GeneralNavigationState({this.leaveChatroom,
    this.loadingUser,this.showChats,
    this.starter=const SearchAndAddUsersScreenImmut(), this.openedChatroomWithId, this.showUserProfileWithId, this.showPersonalProfile});

  @override
  // TODO: implement props
  List<Object?> get props => [starter,openedChatroomWithId,showUserProfileWithId,showPersonalProfile,leaveChatroom];

  GeneralNavigationState copyWith({
    Widget? starter,
    String? openedChatroomWithId,
    String? showUserProfileWithId,
    bool? showPersonalProfile,
    bool? showChats,
    bool? loadingUser,
    bool? leaveChatroom,
  }) {
    return GeneralNavigationState(
      loadingUser: loadingUser,
      showChats: showChats,
      starter: starter??this.starter,
      leaveChatroom: leaveChatroom,
      openedChatroomWithId: openedChatroomWithId,
      showUserProfileWithId: showUserProfileWithId ,
      showPersonalProfile: showPersonalProfile
    );
  }
}