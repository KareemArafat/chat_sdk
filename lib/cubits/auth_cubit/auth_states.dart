abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class LoginLoading extends AuthStates {}

class LoginSuccess extends AuthStates {
  final String token;
  final String apiKey;
  LoginSuccess({required this.token, required this.apiKey});
}

class LoginFailure extends AuthStates {
  String errorMessage;
  LoginFailure({required this.errorMessage});
}

class CheckFailure extends AuthStates {}

class CheckSuccess extends AuthStates {
  final String token;
  final String apiKey;
  CheckSuccess({required this.apiKey, required this.token});
}
