

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/fetch_user_enum.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/users_cubit.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/users_state.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/error_screens/error_loading_user_prof.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/user_graphics_class.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../operations/users/domain/entities/user_data_entity.dart';

class FriendProfileScreen extends StatelessWidget{
  final String uid;
  const FriendProfileScreen({super.key, required this.uid});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    context.read<UserOpCubit>().getUserProfileById(uid);
    return BlocConsumer<UserOpCubit,UserState>
      (builder:(context,userState){
        if(userState.fetchUserStatus==FetchUserStatus.loading){
          return LoadingScreen();
        }
        else if(userState.fetchUserStatus==FetchUserStatus.successful){
          UserData user = userState.user!.first;
          return UserGraphicsClass.of(context).profilePageFormat.copyWith(username: user.username,name: user.name,photoUrl: user.photoURL,numberFriends: user.friends);

        }
        else{
          return ErrorScreen(onRetry:() async => context.read<UserOpCubit>().getUserProfileById(uid));
        }

    }, listener:(context,userState){

    });
  }

}