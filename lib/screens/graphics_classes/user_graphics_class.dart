import 'package:custom_chat_clean_architecture_with_login_firebase/screens/users/friend_profile_widgets/snap_profile.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/users/immut/formats/profile_page_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/users/immut/formats/search_new_users_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/users/immut/formats/user_search_result_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/users/user_add_search_results/user_add_search_result_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../users/search_users_screens/search_user_screen_1.dart';

class UserGraphicsClass extends InheritedWidget{
  final ProfilePageFormat profilePageFormat;
  final SearchNewUsersFormat searchNewUsersFormat;
  final UserSearchResultFormat userSearchResultFormat;
  const UserGraphicsClass(
      {super.key, this.userSearchResultFormat=const UserSearchResult(),
    this.searchNewUsersFormat = const SearchNewUsersDarkMode(),
        this.profilePageFormat = const ProfilePage(), required super.child});
  static UserGraphicsClass of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserGraphicsClass>()!;
  }
  @override
  bool updateShouldNotify(UserGraphicsClass oldWidget) {
    // TODO: implement updateShouldNotify
    return oldWidget.profilePageFormat != profilePageFormat || oldWidget.searchNewUsersFormat!=searchNewUsersFormat || oldWidget.userSearchResultFormat!=userSearchResultFormat;
  }
}

class Random extends Provider{
  Random({required super.create});
  
}