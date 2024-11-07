import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/pic_widget_format.dart';
import 'package:flutter/cupertino.dart';

abstract class UserSearchResultFormat extends StatelessWidget{
  final bool? alreadyAdded;
  final bool? addingUser;
  final bool? requestSent;
  final String? uid;
  final String? header;
  final PicWidgetFormat? profilePic;
  final String? otherInfo;
  final void Function(String)? addUser;
  const UserSearchResultFormat({super.key, this.header, this.profilePic, this.otherInfo, this.addUser, this.alreadyAdded, this.addingUser, this.requestSent, this.uid});

  UserSearchResultFormat copyWith({String?uid,String? header,PicWidgetFormat? profilePic,String? otherInfo,void Function(String)? addUser,bool? alreadyAdded, bool? addingUser, bool? requestSent
  });

}