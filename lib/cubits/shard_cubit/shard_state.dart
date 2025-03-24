abstract class ShardState {}

class CheckInitial extends ShardState {}

class CheckSuccess extends ShardState {}

class CheckFailure extends ShardState {
  final String errorMess;
  CheckFailure({required this.errorMess});
}
