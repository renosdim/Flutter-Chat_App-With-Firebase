import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/pic_widget_format.dart';
import 'package:flutter/material.dart';

import '../immut/formats/user_search_result_format.dart';

// Abstract class


// Concrete implementation
class UserSearchResult extends UserSearchResultFormat {
  const UserSearchResult({
    super.key,
    super.header,
    super.profilePic,
    super.otherInfo,
    super.addUser,
    super.alreadyAdded,
    super.addingUser,
    super.requestSent,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: profilePic,
      title: Text(
        header ?? 'Username',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        otherInfo ?? '',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      trailing: _buildActionButton(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildActionButton() {
    if (alreadyAdded == true) {
      return const Icon(
        Icons.check,
        color: Colors.green,
        size: 28,
      );
    } else if (addingUser == true) {
      return SizedBox(
        width: 70,
        height: 35,
        child: ElevatedButton(
          onPressed: null, // Disable button during loading
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const CircularProgressIndicator(),
        ),
      );
    } else if (requestSent == true) {
      return SizedBox(
        width: 70,
        height: 35,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.green,
            size: 28,
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 70,
        height: 35,
        child: ElevatedButton(
          onPressed: () => addUser?.call(uid ?? ''),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Add'),
        ),
      );
    }
  }

  @override
  UserSearchResultFormat copyWith({String? uid, String? header, PicWidgetFormat? profilePic, String? otherInfo, void Function(String p1)? addUser, bool? alreadyAdded, bool? addingUser, bool? requestSent}) {
    return UserSearchResult(
      header: header ?? this.header,
      profilePic: profilePic ?? this.profilePic,
      otherInfo: otherInfo ?? this.otherInfo,
      addUser: addUser ?? this.addUser,
      alreadyAdded: alreadyAdded ?? this.alreadyAdded,
      addingUser: addingUser ?? this.addingUser,
      requestSent: requestSent ?? this.requestSent,
    );
  }


}