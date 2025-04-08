import 'package:Skillify/src/data/local/model/login/login_model.dart';
import 'package:flutter/widgets.dart';


@immutable
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginLoadedState extends LoginState {
  final LoginModel loginModel;
  LoginLoadedState({required this.loginModel});
}

class LoginErrorState extends LoginState {
  final String error;
  LoginErrorState({required this.error});
}
