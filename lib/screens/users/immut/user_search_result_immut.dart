
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/add_user_cubit.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/add_user_enum.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/add_user_state.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/general_navigation_bloc/general_navigation_cubit.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/chat_graphics_class.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/user_graphics_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class SearchResultImmut extends StatelessWidget{
  final String? uid;
  final String? header;
  final String? profilePic;
  final String? otherInfo;
  const SearchResultImmut({super.key, this.header, this.profilePic, this.otherInfo, this.uid});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(create: (_)=>AddUserCubit(),child: _SearchResultImmut(
      uid: uid,
      header: header,
      profilePic: profilePic,
      otherInfo: otherInfo,
    ),);
  }

}
class _SearchResultImmut extends StatelessWidget{
  final String? uid;
  final String? header;
  final String? profilePic;
  final String? otherInfo;


  const  _SearchResultImmut({super.key, this.header, this.profilePic, this.otherInfo, this.uid});

  @override
  Widget build(BuildContext context) {


    return BlocConsumer<AddUserCubit,AddUserState>(

        builder: (context,addState){
        return UserGraphicsClass.of(context).userSearchResultFormat.copyWith(
          uid: uid,
          header: header,
          profilePic: ChatGraphicsClass.of(context).picWidgetFormat.copyWith(profilePics:[profilePic!],onTap:
          ()=>context.read<GeneralNavigationCubit>().navigateToFriendsProfileWithId(uid: uid!)
          ),
          addingUser: addState.addUserStatus==AddUserStatus.loading,
          alreadyAdded: addState.addUserStatus==AddUserStatus.alreadyAdded,
          requestSent: addState.addUserStatus==AddUserStatus.requestSent,
          addUser: (uid)=>context.read<AddUserCubit>().addUser(uid)
        );
    }, listener:(context,addState){

    });
  }


}

