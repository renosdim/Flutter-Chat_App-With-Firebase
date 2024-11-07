import 'package:flutter/material.dart';

import '../immut/formats/profile_page_format.dart';

class DarkProfilePage extends ProfilePageFormat {
  const DarkProfilePage({
    String? username,
    String? name,
    String? phoneNumber,
    String? photoUrl,
    List<String>? numberFriends,
    void Function()? viewFriendsInfo,
  }) : super(
    username: username,
    name: name,
    phoneNumber: phoneNumber,
    photoUrl: photoUrl,
    numberFriends: numberFriends,
    viewFriendsInfo: viewFriendsInfo,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2E),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(photoUrl ?? ''),
              ),
              const SizedBox(height: 16),
              Text(
                name ?? 'Name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                username ?? '@username',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                phoneNumber ?? 'Phone number not available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: viewFriendsInfo,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF3A3A3C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Friends: ${numberFriends?.length ?? 0}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ProfilePageFormat copyWith({String? username, String? name, String? phoneNumber, String? photoUrl, List<String>? numberFriends, void Function()? viewFriendsInfo}) {
    return DarkProfilePage(
      username: username ?? this.username,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      numberFriends: numberFriends ?? this.numberFriends,
      viewFriendsInfo: viewFriendsInfo ?? this.viewFriendsInfo,
    );
  }
}
