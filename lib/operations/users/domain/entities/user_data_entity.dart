import 'package:equatable/equatable.dart';



// They are the business objects of the application (Enterprise-wide business rules)
// and encapsulate the most general and high-level rules.
abstract class UserData extends Equatable {
  final String uid;
  final String email;
  final String? name;
  final String username;


  final String photoURL;

  final List<String>? friends;
  final String? currentRegToken;

  // For example, a high-level rule for a User entity might be
  // that a user age cannot be lower than 18.
  // final int age;

  const UserData({

    required this.username,

    required this.uid,
    required this.email,
    required this.name,
    required this.photoURL,
    this.friends,

    this.currentRegToken,

  });

  @override
  List<Object?> get props => [uid, name, email, photoURL,username];

// DO NOT ADD THIS CONSTRUCTOR:
// It's not the role of the entity to know how to serialize
// and deserialize data from external data source.
// factory AuthUser.fromJson(Map<String, dynamic> json) {
//   return AuthUser(
//     id: json['id'] as String,
//     name: json['name'] as String,
//     email: json['email'] as String,
//     photoURL: json['photoURL'] as String,
//   );
// }
}
