import 'package:flutter/material.dart';

abstract class SignInFormFormat extends StatelessWidget{


  final Function(String)? onEmailChanged;
  final Function(String)?onPasswordChanged;
  final bool? formInProgress;
  final bool? emailValid;
  final bool? passwordValid;
  final VoidCallback? onSubmit;
  const SignInFormFormat({super.key,
    this.onEmailChanged,
    this.onPasswordChanged,
    this.onSubmit,
    this.formInProgress,
    this.emailValid,
    this.passwordValid,

  });

    @override
    Widget build(BuildContext context);

  SignInFormFormat copyWith({
    Function(String)? onEmailChanged,
    Function(String)? onPasswordChanged,
    bool? formInProgress,
    bool? emailValid,
    bool? passwordValid,
    VoidCallback? onSubmit,
  });
}