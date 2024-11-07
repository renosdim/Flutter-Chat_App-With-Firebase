import 'package:custom_chat_clean_architecture_with_login_firebase/screens/users/immut/user_search_result_immut.dart';
import 'package:flutter/cupertino.dart';

abstract class SearchNewUsersFormat extends StatelessWidget{
  final void Function(String)? getUsersByPrefixFunc;
  final List<SearchResultImmut>? searchResults;


  const SearchNewUsersFormat({super.key, this.getUsersByPrefixFunc, this.searchResults});

  SearchNewUsersFormat copyWith({
    void Function(String)? getUsersByPrefixFunc,
    List<SearchResultImmut>? searchResults,});

}