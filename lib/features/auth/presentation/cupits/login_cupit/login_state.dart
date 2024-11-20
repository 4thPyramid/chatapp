import 'package:chatapp/features/auth/data/domain/entites/user_intity.dart';  // استيراد UserIntity

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserIntity userEntity;

  LoginSuccess({required this.userEntity});
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure({required this.message});
}

