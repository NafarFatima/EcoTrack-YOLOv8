import 'network_result.dart';

/// A generic interface for all network-related operations.
/// This ensures that repositories depend on abstractions, not implementations.
abstract class NetworkService {
  /// Executes a request and wraps the result in a [NetworkResult].
  Future<NetworkResult<T>> call<T>(Future<T> Function() action);

  /// Handles stream-based data with standardized error mapping.
  Stream<T> stream<T>(Stream<T> stream);
}
