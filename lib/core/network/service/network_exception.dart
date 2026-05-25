class NetworkException implements Exception {
  final String message;
  final String? code;

  NetworkException({required this.message, this.code});

  @override
  String toString() => 'NetworkException: $message (code: $code)';
}

class NoInternetException extends NetworkException {
  NoInternetException() : super(message: 'No Internet Connection');
}

class ServerException extends NetworkException {
  ServerException({required super.message, super.code});
}
