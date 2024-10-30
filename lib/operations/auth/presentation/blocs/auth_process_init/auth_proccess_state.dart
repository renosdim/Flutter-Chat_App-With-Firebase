import 'package:equatable/equatable.dart';

class AuthProcessState extends Equatable{
  final bool? loggedIn;
  final bool? loadingDependencies;
  final bool? unloadingDependencies;
  const AuthProcessState({this.loggedIn,this.loadingDependencies,this.unloadingDependencies});

  AuthProcessState copyWith({bool? loggedIn,bool? loadingDependencies,bool?unloadingDependencies}){

    return AuthProcessState(loggedIn: loggedIn,loadingDependencies: loadingDependencies,unloadingDependencies:unloadingDependencies);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [loggedIn,loadingDependencies,unloadingDependencies];
}