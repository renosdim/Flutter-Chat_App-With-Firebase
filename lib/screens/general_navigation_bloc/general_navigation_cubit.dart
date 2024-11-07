
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/general_navigation_bloc/general_navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralNavigationCubit extends Cubit<GeneralNavigationState>{

  GeneralNavigationCubit():super(const GeneralNavigationState());
  
  void navigateToChatsPreview(){
    emit(state.copyWith(showChats: true));
  }

  void navigateToChatroomWithId(String chatroomId){
    emit(state.copyWith(openedChatroomWithId: chatroomId));
    emit(state.copyWith());
  }
  void leaveChatroom(){

    emit(state.copyWith(openedChatroomWithId: null,leaveChatroom: true));
    emit(state.copyWith());
    //emit(state.copyWith(openedChatroomWithId: null,leaveChatroom: false));
  }

  void navigateToFriendsProfileWithId({required String uid}){

    emit(state.copyWith(showUserProfileWithId: uid));
    emit(state.copyWith());

  }
  
}