import '../sign_in_form_format.dart';
import 'package:flutter/material.dart';

class SignInForm1 extends SignInFormFormat {
  const SignInForm1({super.onEmailChanged, super.onPasswordChanged,  super.onSubmit,super.formInProgress, super.emailValid,super.passwordValid});



  @override
  Widget build(BuildContext context) {
    print('email valid $emailValid');
    // TODO: implement call
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Welcome Text
          Text(
            'Welcome Back',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'Sign in to continue',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32.0),

          // Email Input
          TextFormField(
            key: const Key('signIn_emailInput_textField'),
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              labelStyle: const TextStyle(color: Colors.white),
              errorText: !emailValid!
                  ? 'Please enter a valid email'
                  : null,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: onEmailChanged!,
          ),

          const SizedBox(height: 16.0),

          // Password Input
          TextFormField(
            key: const Key('signIn_passwordInput_textField'),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              labelStyle: const TextStyle(color: Colors.black87),
              errorText: !passwordValid!
                  ? 'Please enter a valid password'
                  : null,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
            onChanged: onPasswordChanged,
          ),

          const SizedBox(height: 24.0),

          // Sign In Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('signIn_continue_elevatedButton'),
              onPressed:formInProgress!
                  ? null
                  : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: formInProgress!
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
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
    return SignInForm1(
      onEmailChanged: onEmailChanged ?? this.onEmailChanged,
      onPasswordChanged: onPasswordChanged ?? this.onPasswordChanged,
      formInProgress: formInProgress ?? this.formInProgress,
      emailValid: emailValid ?? this.emailValid,
      passwordValid: passwordValid ?? this.passwordValid,
      onSubmit: onSubmit ?? this.onSubmit,
    );
  }

}
