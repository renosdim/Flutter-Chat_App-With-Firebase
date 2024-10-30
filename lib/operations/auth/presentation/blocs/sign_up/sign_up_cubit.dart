// import 'dart:io';
//
//
// import 'package:bloc/bloc.dart';
// import 'package:either_dart/either.dart';
// import 'package:equatable/equatable.dart';
//
// import '../../../domain/use_cases/sign_up_use_case.dart';
// import '../../../domain/value_objects/email.dart';
// import '../../../domain/value_objects/password.dart';
// import '../dob_status.dart';
// import '../email_status.dart';
// import '../form_status.dart';
// import '../name_status.dart';
// import '../password_status.dart';
// import '../profile_pic_status.dart';
// import '../sex_status.dart';
//
// part 'sign_up_state.dart';
//
// class SignUpCubit extends Cubit<SignUpState> {
//   final SignUpUseCase _signUpUseCase;
//   final CheckUsernameExistenceUseCase _getUsersByPrefix;
//
//   SignUpCubit({
//     required SignUpUseCase signUpUseCase,
//     required CheckUsernameExistenceUseCase getUsersByPrefix
//   })  : _signUpUseCase = signUpUseCase,_getUsersByPrefix = getUsersByPrefix,
//         super(const SignUpState());
//   bool _checkUsernameValidity(String input) {
//     RegExp pattern = RegExp(r'^[A-Za-z._]{4,}$');
//     RegExp letterPattern = RegExp(r'[A-Za-z]');
//     return pattern.hasMatch(input) && letterPattern.allMatches(input).length >= 4;
//   }
//   bool _containsOnlyLettersAndAboveFour(String input) {
//     // Define a regular expression pattern to match only letters
//     RegExp regex = RegExp(r'^[a-zA-Z]{5,}$');
//
//     // Test if the input string matches the pattern
//     return regex.hasMatch(input);
//   }
//   String? nameChanged(String value){
//     if(_containsOnlyLettersAndAboveFour(value)){
//       emit(state.copyWith(name:value,nameStatus: NameStatus.valid));
//       return null;
//     }
//     else{
//       emit(state.copyWith(nameStatus: NameStatus.invalid));
//       return 'must contain only letters dumbass';
//     }
//   }
//   String? dobChanged(DateTime dateTime){
//     if(dateTime.difference(DateTime(DateTime.now().year-18)).inDays>0){
//       print(DateTime.now().difference(dateTime).inDays);
//       emit(state.copyWith(dobStatus: DobStatus.invalid));
//       return 'Ρε φιλε πες ψεμματα αν ειναι ελεος!';
//     }
//     else{
//       emit(state.copyWith(dob: dateTime,dobStatus: DobStatus.valid));
//       return null;
//     }
//   }
//   void sexChanged(String sex){
//     emit(state.copyWith(sex: sex,sexStatus: SexStatus.valid));
//
//   }
//   void selectPic(File file){
//     emit(state.copyWith(profilePic: file,profilePicStatus: ProfilePicStatus.chosen));
//   }
//   Future<String?> usernameChanged(String value) async {
//     if(_checkUsernameValidity(value)){
//       Either<Failure,bool> existingUsers = await _getUsersByPrefix(value);
//       if(existingUsers.isRight){
//         print(existingUsers.right);
//         if(!existingUsers.right){
//           emit(state.copyWith(usernameStatus: UsernameStatus.taken));
//           return 'taken';
//         }
//         else{
//           emit(state.copyWith(username: value,usernameStatus: UsernameStatus.valid));
//           return null;
//         }
//       }
//       else{
//         emit(state.copyWith(usernameStatus: UsernameStatus.inadequate));
//         return existingUsers.left.message;
//       }
//
//     }
//     else{
//       print('inadequate');
//       emit(state.copyWith(usernameStatus: UsernameStatus.inadequate));
//       return 'inadequate';
//     }
//   }
//   String? emailChanged(String value) {
//     if(value.isEmpty){
//       emit(state.copyWith(emailStatus: EmailStatus.unknown));
//     }
//     else{
//       try {
//         Email email = Email((email) => email..value = value);
//         emit(
//           state.copyWith(
//             email: email,
//             emailStatus: EmailStatus.valid,
//           ),
//         );
//         return null;
//       } on ArgumentError {
//         emit(state.copyWith(emailStatus: EmailStatus.invalid));
//
//         return 'το κοβεις για email αυτο εσυ τωρα?';
//       }
//     }
//
//   }
//
//   String? passwordChanged(String value) {
//     if(value.isEmpty){
//       print('password');
//       emit(
//         state.copyWith(
//
//           passwordStatus: PasswordStatus.unknown,
//         ),
//       );
//     }
//     else{
//       try {
//         Password password = Password((password) => password..value = value);
//         emit(
//           state.copyWith(
//             password: password,
//             passwordStatus: PasswordStatus.toBecomfirmed,
//           ),
//         );
//         return null;
//       } on ArgumentError {
//         emit(state.copyWith(passwordStatus: PasswordStatus.invalid));
//       }
//       return 'και πενταχρονο θα μαντευε αυτον τον κωδικο';
//     }
//
//   }
//   String? verifyPassword(String value){
//     if(state.passwordStatus==PasswordStatus.invalid) {
//
//     }
//     else if(state.password?.value!=value){
//       return 'Δεν ματσαριυν οι κωδικοι μαν!';
//     }
//     else{
//       try {
//         Password password = Password((password) => password..value = value);
//         emit(
//           state.copyWith(
//             password: password,
//             passwordStatus: PasswordStatus.valid,
//           ),
//         );
//         return null;
//       } on ArgumentError {
//         emit(
//           state.copyWith(
//
//             passwordStatus: PasswordStatus.duplicateInvalid,
//           ),
//         );
//       }
//
//     }
//   }
//
//
//   Future<bool> signUp() async {
//     if (!(state.emailStatus == EmailStatus.valid) ||
//         !(state.passwordStatus == PasswordStatus.valid)) {
//       emit(state.copyWith(formStatus: FormStatus.invalid));
//       emit(state.copyWith(formStatus: FormStatus.initial));
//       return false;
//     }
//
//     emit(state.copyWith(formStatus: FormStatus.submissionInProgress));
//     try {
//       await _signUpUseCase(
//         SignUpParams(email: state.email!, password: state.password!,userDocDetails: state.toMap()),
//       );
//       emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
//       return true;
//     } catch (err) {
//       emit(state.copyWith(formStatus: FormStatus.submissionFailure));
//       return false;
//     }
//   }
// }
