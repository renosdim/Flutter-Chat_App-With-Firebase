//
// part of 'sign_up_cubit.dart';
//
// class SignUpState extends Equatable {
//   final Email? email;
//   final Password? password;
//   final String? username;
//   final DateTime? dob;
//   final String? name;
//   final NameStatus nameStatus;
//   final File? profilePic;
//   final String? sex;
//   final SexStatus sexStatus;
//   final ProfilePicStatus profilePicStatus;
//
//
//   final DobStatus dobStatus;
//   final UsernameStatus usernameStatus;
//   final EmailStatus emailStatus;
//   final PasswordStatus passwordStatus;
//   final FormStatus formStatus;
//
//   const SignUpState( {
//     this.sex,
//     this.sexStatus = SexStatus.unknown,
//     this.profilePic, this.profilePicStatus=ProfilePicStatus.unknown,
//     this.email,
//     this.password,
//     this.dob,
//     this.name,
//     this.nameStatus = NameStatus.unknown,
//     this.usernameStatus = UsernameStatus.unknown,
//     this.dobStatus = DobStatus.unknown,
//     this.username,
//     this.emailStatus = EmailStatus.unknown,
//     this.passwordStatus = PasswordStatus.unknown,
//     this.formStatus = FormStatus.initial,
//   });
//
//   SignUpState copyWith({
//     Email? email,
//     Password? password,
//     String? username,
//     DateTime? dob,
//     String? name,
//     ProfilePicStatus? profilePicStatus,
//     String? sex,
//     SexStatus? sexStatus,
//     File? profilePic,
//     NameStatus? nameStatus,
//     DobStatus? dobStatus,
//     UsernameStatus? usernameStatus,
//     EmailStatus? emailStatus,
//     PasswordStatus? passwordStatus,
//     FormStatus? formStatus,
//   }) {
//     return SignUpState(
//       username: username??this.username,
//       usernameStatus: usernameStatus?? this.usernameStatus,
//       profilePic: profilePic?? this.profilePic,
//       sex: sex??this.sex,
//       sexStatus: sexStatus?? this.sexStatus,
//       profilePicStatus: profilePicStatus??this.profilePicStatus,
//       dob: dob??this.dob,
//       name: name??this.name,
//       nameStatus: nameStatus?? this.nameStatus,
//       dobStatus: dobStatus??this.dobStatus,
//       email: email ?? this.email,
//       password: password ?? this.password,
//       emailStatus: emailStatus ?? this.emailStatus,
//       passwordStatus: passwordStatus ?? this.passwordStatus,
//       formStatus: formStatus ?? this.formStatus,
//     );
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       'email': email,
//       'username': username,
//       'dob': dob,
//       'name': name,
//       'profilePic': profilePic,
//       'sex': sex,
//
//     };
//   }
//   @override
//   List<Object?> get props => [
//         email,
//         password,
//         emailStatus,
//         passwordStatus,
//         formStatus,
//         name,
//         dob,
//         sex,
//         sexStatus,
//         dobStatus,
//     profilePicStatus,
//     profilePic,
//         nameStatus,
//         usernameStatus,
//         username,
//       ];
// }
