import 'package:flutter/widgets.dart';

@immutable
abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final String message;

  RegisterSuccessState({required this.message});
}

class RegisterErrorState extends RegisterState {
  final String error;

  RegisterErrorState({required this.error});
}
