import 'package:firebase_auth/firebase_auth.dart';
import 'network_exception.dart';
import 'network_info.dart';

/// Base class for all remote services/data sources to ensure consistent
/// error handling and connectivity checks.
abstract class BaseNetworkService {
  final NetworkInfo networkInfo;

  BaseNetworkService(this.networkInfo);

  /// Wraps a network call with connectivity check and Firebase exception handling.
  Future<T> runWithExceptionHandling<T>(Future<T> Function() action) async {
    if (!await networkInfo.isConnected) {
      throw NoInternetException();
    }

    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'An authentication error occurred',
        code: e.code,
      );
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'A database error occurred',
        code: e.code,
      );
    } catch (e) {
      throw NetworkException(
        message: e.toString(),
      );
    }
  }

  /// Specialized wrapper for Streams (e.g., Firestore snapshots).
  Stream<T> mapStreamException<T>(Stream<T> stream) {
    return stream.handleError((error) {
      if (error is FirebaseException) {
        throw ServerException(
          message: error.message ?? 'Stream error occurred',
          code: error.code,
        );
      }
      throw NetworkException(message: error.toString());
    });
  }
}
