import 'package:flutter/material.dart';

import '../immut/formats/search_new_users_format.dart';
import '../immut/user_search_result_immut.dart';

class SearchNewUsersGradient extends SearchNewUsersFormat {
  const SearchNewUsersGradient({
    super.key,
    super.getUsersByPrefixFunc,
    super.searchResults,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Find Friends",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A90E2), Color(0xFF9013FE)],
          ),
        ),
        child: Column(
          children: [
            // Spacer to push the search bar below the AppBar in gradient
            const SizedBox(height: 80),
            // Search bar with colorful accent
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (query) => getUsersByPrefixFunc?.call(query),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: "Search by username",
                    hintStyle: const TextStyle(color: Colors.grey),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: searchResults![index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  SearchNewUsersFormat copyWith({
    void Function(String)? getUsersByPrefixFunc,
    List<SearchResultImmut>? searchResults,
  }) {
    return SearchNewUsersGradient(
      getUsersByPrefixFunc: getUsersByPrefixFunc ?? this.getUsersByPrefixFunc,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
