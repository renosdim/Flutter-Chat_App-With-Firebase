
import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';


import '../../../../operations/chat/regular_chat/domain/usecases/find_friends_to_text.dart';
import '../../../../operations/chat/regular_chat/dtos/chat_participant_dto.dart';
import '../../../../operations/common/failures/failure.dart';


class SearchToChatNotifier extends ChangeNotifier{

  final Map<String,ChatParticipantDTO> tags = {};
  ChatParticipantDTO? selectedTag = null;
  bool isLoading = false;
  Set<ChatParticipantDTO> filteredTags = {};
  final FindFriendsToText _findFriendsToText;
  SearchToChatNotifier({required FindFriendsToText findFriendsToText}):_findFriendsToText = findFriendsToText;
  void selectTag(ChatParticipantDTO chatParticipantDTO){

    selectedTag = chatParticipantDTO;
    notifyListeners();
  }
  void unselectTag(ChatParticipantDTO chatParticipantDTO){
    selectedTag = null;
    notifyListeners();
  }

  void onChanged(String prefix) async {
    if (prefix.isEmpty) {
      filteredTags = {};
      notifyListeners();
    }
    else {
      List<ChatParticipantDTO> newFiltered = tags.values
          .where((friend) =>
      friend.name!.toLowerCase().startsWith(prefix.toLowerCase()) )
          .toList();

      if (newFiltered.length <= 2) {
        Either<Failure,
            List<ChatParticipantDTO>> list = await _findFriendsToText(
            7, true, tags.values.map((e) => e.uid).toList(), prefix);
        if (list.isRight) {
          filteredTags = {...newFiltered, ...list.right.toSet()};
          for (ChatParticipantDTO i in filteredTags) {
            if (tags[i.uid] == null) {
              tags[i.uid] = i;

            }
          }
          notifyListeners();
        }
      }
      else {
        filteredTags = newFiltered.toSet();
        notifyListeners();
      }
    }
  }
  void _setLoadingTo(bool what) {
    isLoading = what;
    notifyListeners();
  }
  void loadMoreUsers() async {
    _setLoadingTo(true);
    Either<Failure, List<ChatParticipantDTO>> list = await _findFriendsToText(
         7 , true, tags.values.map((e) => e.uid).toList());
    if (list.isRight) {
      for(ChatParticipantDTO i in list.right){
        tags[i.uid] = i;
      }
    }
    _setLoadingTo(false);
  }

}