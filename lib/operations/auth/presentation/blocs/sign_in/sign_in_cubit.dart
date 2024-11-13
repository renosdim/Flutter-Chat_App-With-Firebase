import 'package:bloc/bloc.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/use_cases/sign_in_use_case.dart';
import '../../../domain/value_objects/email.dart';
import '../../../domain/value_objects/password.dart';

import '../email_status.dart';
import '../form_status.dart';
import '../password_status.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInUseCase _signInUseCase;
  final AuthRemoteDataSource authRemoteDataSource;

  SignInCubit({required this.authRemoteDataSource, 
    required SignInUseCase signInUseCase,
   
  })  : _signInUseCase = signInUseCase,
        super(const SignInState());

  void emailChanged(String value) {
    try {
      Email email = Email((email) => email..value = value);
      emit(
        state.copyWith(
          email: email,
          emailStatus: EmailStatus.valid,
        ),
      );
    } on ArgumentError {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    }
  }

  void passwordChanged(String value) {
    try {
      Password password = Password((password) => password..value = value);
      emit(
        state.copyWith(
          password: password,
          passwordStatus: PasswordStatus.valid,
        ),
      );
    } on ArgumentError {
      emit(state.copyWith(passwordStatus: PasswordStatus.invalid));
    }
  }

  Future<void> signIn() async {
    

    emit(state.copyWith(formStatus: FormStatus.submissionInProgress));
    try {
      await _signInUseCase(
        SignInParams(email: state.email!, password: state.password!)
      );

      emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
    } catch (err) {
      print(err);
      emit(state.copyWith(formStatus: FormStatus.submissionFailure));
    }
  }
}
