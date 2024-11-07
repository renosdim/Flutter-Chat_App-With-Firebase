

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/users_cubit.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/users_state.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/user_graphics_class.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/users/immut/user_search_result_immut.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchAndAddUsersScreenImmut extends StatelessWidget{
  const SearchAndAddUsersScreenImmut({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocConsumer<UserOpCubit,UserState>(
      listenWhen: (previous,current)=>previous.user!=current.user || previous.fetchUserStatus!=current.fetchUserStatus,
      builder: (context,userState){
        return UserGraphicsClass.of(context).searchNewUsersFormat.copyWith(
          getUsersByPrefixFunc:(prefix)=> context.read<UserOpCubit>().getUsersByPrefix(prefix,userState.user?.map((e)=>e.uid).toList()),
          searchResults: userState.user?.map((user)=>SearchResultImmut(uid:user.uid,header:user.name??user.username,profilePic: user.photoURL,)).toList()
        );
      },
      listener: (BuildContext context, UserState state) {  },
    );
  }


}