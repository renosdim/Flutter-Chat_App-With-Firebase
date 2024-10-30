import 'package:flutter/material.dart';

import '../sign_in_form_format.dart';

class ElegantSignInForm extends SignInFormFormat {
  const ElegantSignInForm({
    Key? key,
    Function(String)? onEmailChanged,
    Function(String)? onPasswordChanged,
    VoidCallback? onSubmit,
    bool? formInProgress,
    bool? emailValid,
    bool? passwordValid,
  }) : super(
    key: key,
    onEmailChanged: onEmailChanged,
    onPasswordChanged: onPasswordChanged,
    onSubmit: onSubmit,
    formInProgress: formInProgress,
    emailValid: emailValid,
    passwordValid: passwordValid,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: onEmailChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white54),
                    fillColor: Colors.white24,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  onChanged: onPasswordChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white54),
                    fillColor: Colors.white24,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  SignInFormFormat copyWith({
    Function(String)? onEmailChanged,
    Function(String)? onPasswordChanged,
    bool? formInProgress,
    bool? emailValid,
    bool? passwordValid,
    VoidCallback? onSubmit,
  }) {
    return ElegantSignInForm(
      onEmailChanged: onEmailChanged ?? this.onEmailChanged,
      onPasswordChanged: onPasswordChanged ?? this.onPasswordChanged,
      onSubmit: onSubmit ?? this.onSubmit,
      formInProgress: formInProgress ?? this.formInProgress,
      emailValid: emailValid ?? this.emailValid,
      passwordValid: passwordValid ?? this.passwordValid,
    );
  }
}
