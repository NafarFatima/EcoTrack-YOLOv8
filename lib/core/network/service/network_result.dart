import 'network_exception.dart';

/// A sealed class representing the result of a network operation.
abstract class NetworkResult<T> {
  const NetworkResult();
}

class NetworkSuccess<T> extends NetworkResult<T> {
  final T data;
  const NetworkSuccess(this.data);
}

class NetworkFailure<T> extends NetworkResult<T> {
  final NetworkException exception;
  const NetworkFailure(this.exception);
}
