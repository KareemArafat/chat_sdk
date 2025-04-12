abstract class ShardState {}

class CheckInitial extends ShardState {}

class CheckSuccess extends ShardState {
  final String token;
  CheckSuccess({required this.token});
}

class CheckFailure extends ShardState {
  final String errorMess;
  CheckFailure({required this.errorMess});
}
