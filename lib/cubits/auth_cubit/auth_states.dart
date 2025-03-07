abstract class AuthStates {}

class LoginInitial extends AuthStates {}

class LoginLoading extends AuthStates {}

class LoginSuccess extends AuthStates {}

class LoginFailure extends AuthStates {
  String errorMessage;
  LoginFailure({required this.errorMessage});
}

class SignInitial extends AuthStates {}

class SignLoading extends AuthStates {}

class SignSuccess extends AuthStates {}

class SignFailure extends AuthStates {
  String errorMessage;
  SignFailure({required this.errorMessage});
}
