import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/pic_widget_format.dart';


import 'package:flutter/material.dart';

class PicWidget1 extends PicWidgetFormat {
  const PicWidget1({super.profilePics,super.onTap, super.key});

  Widget gestureDetect(Widget widget){
    return GestureDetector(
      onTap:(){
        onTap!();
      },
      child: widget,
    );
  }
  @override
  Widget build(BuildContext context) {
    if (profilePics == null || profilePics!.isEmpty) {
      return gestureDetect(_defaultPlaceholder());
    } else if (profilePics!.length == 1) {
      return gestureDetect(_buildSingleProfilePic(profilePics![0]));
    } else {
      return gestureDetect(_buildGroupProfilePics(profilePics!));
    }
  }

  // Fallback in case no profile pics are provided
  Widget _defaultPlaceholder() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey[400],
      child: Icon(Icons.person, color: Colors.white),
    );
  }

  // Build a single profile picture in a circular avatar
  Widget _buildSingleProfilePic(String profilePic) {
    return CircleAvatar(
      radius: 24, // Adjust radius as per design
      backgroundImage: NetworkImage(profilePic),
    );
  }

  // Build profile pictures for group chat
  Widget _buildGroupProfilePics(List<String> profilePics) {
    // Show up to 4 profile pictures; if more, display "+N"
    final displayPics = profilePics.take(4).toList();
    final extraCount = profilePics.length - displayPics.length;

    return SizedBox(
      width: 48, // Adjust size as needed
      height: 48,
      child: Stack(
        children: [
          // Layout profile pictures in different positions depending on the count
          for (int i = 0; i < displayPics.length; i++)
            Positioned(
              left: _getLeftPosition(displayPics.length, i),
              top: _getTopPosition(displayPics.length, i),
              child: _buildSmallCircle(profilePics[i]),
            ),

          // If there are extra participants, add a "+N" widget
          if (extraCount > 0)
            Positioned(
              right: 0,
              bottom: 0,
              child: _buildMoreCircle(extraCount),
            ),
        ],
      ),
    );
  }

  // Helper to build small circular avatars for group chat members
  Widget _buildSmallCircle(String profilePic) {
    return CircleAvatar(
      radius: 12, // Smaller radius for group profile pictures
      backgroundImage: NetworkImage(profilePic),
      backgroundColor: Colors.grey[300],
    );
  }

  // Helper to build "+N" circle for extra participants
  Widget _buildMoreCircle(int extraCount) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: Colors.grey[400],
      child: Text(
        '+$extraCount',
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
        ),
      ),
    );
  }

  // Determine left position for profile pictures based on the number of pictures
  double _getLeftPosition(int count, int index) {
    switch (count) {
      case 2:
        return index == 0 ? 0 : 24;
      case 3:
        return index == 0 ? 0 : (index == 1 ? 24 : 12);
      case 4:
        return index % 2 == 0 ? 0 : 24;
      default:
        return 0;
    }
  }

  // Determine top position for profile pictures based on the number of pictures
  double _getTopPosition(int count, int index) {
    switch (count) {
      case 2:
        return index == 0 ? 0 : 24;
      case 3:
        return index < 2 ? 0 : 24;
      case 4:
        return index < 2 ? 0 : 24;
      default:
        return 0;
    }
  }

  @override
  PicWidgetFormat copyWith({List<String>? profilePics,VoidCallback? onTap}) {
    return PicWidget1(profilePics: profilePics??this.profilePics,onTap: onTap??this.onTap,);
  }
}
