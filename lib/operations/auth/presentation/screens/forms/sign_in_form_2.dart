import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/common/color.dart';
import 'package:flutter/material.dart';

import '../sign_in_form_format.dart';

class ModernSignInForm extends SignInFormFormat {
  const ModernSignInForm({
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    style: TextStyle(
                      color: black,
                    ),
                    onChanged: onEmailChanged,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const UnderlineInputBorder(),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      // Display error message if emailValid is false
                      errorText: (emailValid == false) ? 'Invalid email' : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: TextStyle(
                      color: black,
                    ),
                    obscureText: true,
                    onChanged: onPasswordChanged,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const UnderlineInputBorder(),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      // Display error message if passwordValid is false
                      errorText: (passwordValid == false) ? 'Invalid password' : null,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: onSubmit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadowColor: Colors.black12,
                      elevation: 6,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (formInProgress ?? false)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
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
    return ModernSignInForm(
      onEmailChanged: onEmailChanged ?? this.onEmailChanged,
      onPasswordChanged: onPasswordChanged ?? this.onPasswordChanged,
      onSubmit: onSubmit ?? this.onSubmit,
      formInProgress: formInProgress ?? this.formInProgress,
      emailValid: emailValid ?? this.emailValid,
      passwordValid: passwordValid ?? this.passwordValid,
    );
  }
}
