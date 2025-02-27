import 'dart:async';
import 'package:custom_chat_clean_architecture_with_login_firebase/flexibleApp/flexible_app_main.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/injection.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/presentation/screens/forms/sign_in_form3.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/presentation/screens/forms/sign_in_form_2.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/auth_graphics_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/sign_in_use_case.dart';
import '../blocs/email_status.dart';
import '../blocs/form_status.dart';
import '../blocs/password_status.dart';
import '../blocs/sign_in/sign_in_cubit.dart';


class SignInScreen extends StatelessWidget {

  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(
        authRemoteDataSource: serviceLocator<AuthRemoteDataSource>(),
        signInUseCase: SignInUseCase(
        
        authRepository: context.read<AuthRepository>(),
        ),
      ),
      child: const _SignInView(),
    );
  }
}

class _SignInView extends StatefulWidget {

  const _SignInView({super.key});

  @override
  State<_SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<_SignInView> {
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) async  {
          if (state.formStatus == FormStatus.invalid) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Invalid form: please fill in all fields'),
                ),
              );
          }
          if (state.formStatus == FormStatus.submissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'There was an error with the sign in process. Try again.',
                  ),
                ),
              );
          }

        },
        builder: (context, state) {


          Widget signInForm =   AuthGraphicsClass.of(context).signInFormFormat.copyWith(


            emailValid: state.emailStatus==EmailStatus.valid || state.emailStatus==EmailStatus.unknown,

            passwordValid: state.passwordStatus==PasswordStatus.valid || state.passwordStatus==PasswordStatus.unknown,
            onEmailChanged: (String value) {
              print('on chagmged email $value');
              if (debounce?.isActive ?? false) debounce?.cancel();
              debounce = Timer(const Duration(milliseconds: 500), () {
                context.read<SignInCubit>().emailChanged(value);
              });
            },
            onPasswordChanged: (String value) {
              context.read<SignInCubit>().passwordChanged(value);
            },
             onSubmit: () {
              context.read<SignInCubit>().signIn();
            }, formInProgress: state.formStatus==FormStatus.submissionInProgress,
          );
          return signInForm;
        },

      ),
    );
  }
}


