import 'package:flutter/cupertino.dart';

abstract class ProfilePageFormat extends StatelessWidget {
  final String? username;
  final String? name;
  final String? phoneNumber;
  final String? photoUrl;
  final List<String>? numberFriends;
  final void Function()? viewFriendsInfo;

  const ProfilePageFormat({
    this.username,
    this.name,
    this.phoneNumber,
    this.photoUrl,
    this.numberFriends,
    this.viewFriendsInfo,
  });

  // CopyWith function to create a new instance with modified properties
  ProfilePageFormat copyWith({
    String? username,
    String? name,
    String? phoneNumber,
    String? photoUrl,
    List<String>? numberFriends,
    void Function()? viewFriendsInfo,
  });

  @override
  Widget build(BuildContext context);
}
