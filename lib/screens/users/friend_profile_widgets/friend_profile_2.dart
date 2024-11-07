import 'package:flutter/material.dart';

import '../immut/formats/profile_page_format.dart';

class GlassProfilePage extends ProfilePageFormat {
  const GlassProfilePage({
    super.username,
    super.name,
    super.phoneNumber,
    super.photoUrl,
    super.numberFriends,
    super.viewFriendsInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                username ?? '@username',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
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
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Friends: ${numberFriends?.length ?? 0}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.7),
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
    // TODO: implement copyWith
    return GlassProfilePage(
      username: username ?? this.username,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      numberFriends: numberFriends ?? this.numberFriends,
      viewFriendsInfo: viewFriendsInfo ?? this.viewFriendsInfo,
    );
  }
}
