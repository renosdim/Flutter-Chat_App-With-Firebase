import 'package:flutter/material.dart';

import '../immut/formats/search_new_users_format.dart';
import '../immut/user_search_result_immut.dart';

class SearchNewUsersDarkMode extends SearchNewUsersFormat {
  const SearchNewUsersDarkMode({
    super.key,
    super.getUsersByPrefixFunc,
    super.searchResults,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Add Friends",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (query) => getUsersByPrefixFunc?.call(query),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  hintText: "Search by username",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          // Display search results
          Expanded(
            child: ListView.builder(
              itemCount: searchResults?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: searchResults![index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  SearchNewUsersFormat copyWith({
    void Function(String)? getUsersByPrefixFunc,
    List<SearchResultImmut>? searchResults,
  }) {
    return SearchNewUsersDarkMode(
      getUsersByPrefixFunc: getUsersByPrefixFunc ?? this.getUsersByPrefixFunc,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
