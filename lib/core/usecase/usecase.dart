import '../errors/failures.dart';

/// Either generic construct for functional Clean Architecture without external fp library
class Either<L extends Failure, R> {
  final L? _left;
  final R? _right;
  final bool isRight;

  const Either._(this._left, this._right, this.isRight);

  factory Either.left(L left) => Either._(left, null, false);
  factory Either.right(R right) => Either._(null, right, true);

  bool get isLeft => !isRight;

  T fold<T>(T Function(L failure) onLeft, T Function(R data) onRight) {
    if (isRight) {
      final right = _right;
      return onRight(right as R);
    } else {
      final left = _left;
      return onLeft(left!);
    }
  }
}

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {
  const NoParams();
}
