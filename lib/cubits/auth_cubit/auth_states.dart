abstract class AuthStates {}

class AuthInitial extends AuthStates {}



class LoginLoading extends AuthStates {}
class LoginSuccess extends AuthStates {
  final String token;
  LoginSuccess({required this.token});
}
class LoginFailure extends AuthStates {
  String errorMessage;
  LoginFailure({required this.errorMessage});
}



class SignLoading extends AuthStates {}
class SignSuccess extends AuthStates {}
class SignFailure extends AuthStates {
  String errorMessage;
  SignFailure({required this.errorMessage});
}



class CheckInitial extends AuthStates {}
class CheckSuccess extends AuthStates {
  final String token;
  CheckSuccess({required this.token});
}
class CheckFailure extends AuthStates {
  final String errorMess;
  CheckFailure({required this.errorMess});
}
