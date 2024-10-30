
import 'package:cloud_firestore/cloud_firestore.dart';



import '../../../common/constants.dart';
import '../../domain/entities/user_data_entity.dart';

class UserDataModel extends UserData{
  const UserDataModel({super.currentRegToken,required super.username,super.friends,required super.photoURL, required super.uid, required super.email, required super.name});
  factory UserDataModel.fromDocument(DocumentSnapshot document,[String? regToken]) {
    Map<String,dynamic> doc = document.data() as Map<String,dynamic>;
    print('ffff: ${doc['friends']}');
    if(doc['username']==null){
      print('invalid');
      throw ArgumentError();
    }
    UserDataModel userData = UserDataModel(
        uid: document.id,
        name:doc['name'],
        username:doc['username'],

        friends: List<String>.from(doc['friends']??[]),
        currentRegToken: regToken,
        email: doc['email'], photoURL: doc['profilePic']??defaultProfilePic);

    return userData;
  }
  UserDataModel addChatList(Map<String,dynamic>? existing){
    return UserDataModel(username: username, photoURL: photoURL,uid: uid, email: email, name: name);
  }

}