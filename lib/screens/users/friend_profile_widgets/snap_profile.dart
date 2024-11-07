

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../immut/formats/profile_page_format.dart';

class ProfilePage extends ProfilePageFormat{
  

  const ProfilePage({
    
    super.username,
    super.name,
    super.photoUrl,
    super.numberFriends,
    super.phoneNumber,
    super.viewFriendsInfo
  });
  int adjustLength(int individualLength,double screenWidth,{int currentLength=0}){
    if(currentLength>=screenWidth){
      double length =  (currentLength-individualLength)/individualLength;
      int lengthInt = length.toInt();
      if(lengthInt>length){
        return lengthInt-1;
      }
      else{
        return lengthInt;
      }

  }
    else{
      return adjustLength(individualLength,currentLength:currentLength+individualLength ,screenWidth);
  }

  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    print('screen widdth');
    print(screenWidth);
    int  length = numberFriends!.length;
    final acceptedLength = adjustLength(80, screenWidth);
    print('accepted length $acceptedLength');
    if(acceptedLength<length){
      length = acceptedLength.toInt();
  }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background with gradient and image
          Positioned(
            top: 0,
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.purpleAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                image: DecorationImage(
                  image: const NetworkImage(defaultProfilePic),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),

          // Overlapping Container
          Positioned(
            top: 220, // Adjust to control the amount of overlap
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: screenHeight - 220, // Remaining height to prevent overflow
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10, vertical: 20),
                  child: Column(
                    children: [
                      // Profile Info Row with Profile Picture, Name, and Username
                      Padding(
                        padding: const EdgeInsets.only(left:  8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Picture
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: photoUrl != null
                                    ? NetworkImage(photoUrl!)
                                    : AssetImage('assets/default_profile.png') as ImageProvider,
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Name and Username
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  name ?? 'User Name',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '@${username ?? 'username'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                          'Capricorn',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Friends Count Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            numberFriends!.length.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Friends',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Buttons: Add Friends and View Friends List
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CupertinoButton(
                              color: Colors.blueAccent,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              borderRadius: BorderRadius.circular(20),
                              child: Text(
                                'Add Friends',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              onPressed:()=>{},
                            ),
                            const SizedBox(width: 10),
                            CupertinoButton(
                              color: Colors.grey[300],
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              borderRadius: BorderRadius.circular(20),
                              child: Text(
                                'My Friends',
                                style: TextStyle(color: Colors.black, fontSize: 16),
                              ),
                              onPressed:()=>{},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Friends List Section
                      SizedBox(
                        height: 100,
                        width: screenWidth,
                        child: Center(

                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(''),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  ProfilePageFormat copyWith({String? username, String? name, String? phoneNumber, String? photoUrl, List<String>? numberFriends, void Function()? viewFriendsInfo}) {
    // TODO: implement copyWith
    return  ProfilePage(
      username: username ?? this.username,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      numberFriends: numberFriends ?? this.numberFriends,
      viewFriendsInfo: viewFriendsInfo ?? this.viewFriendsInfo,
    );
  }
}
