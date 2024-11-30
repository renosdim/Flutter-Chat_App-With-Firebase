
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/presentation/screens/forms/sign_in_form_1.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/presentation/screens/sign_in_form_format.dart';
import 'package:flutter/widgets.dart';
class AuthGraphicsClassAttributes {
  final SignInFormFormat signInFormFormat;
  const AuthGraphicsClassAttributes({this.signInFormFormat=const SignInForm1()});
}
class AuthGraphicsClass extends InheritedWidget {
  final SignInFormFormat signInFormFormat;
  const AuthGraphicsClass({super.key,this.signInFormFormat=const SignInForm1(), required super.child});

  static AuthGraphicsClass of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthGraphicsClass>()!;
  }
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }


}