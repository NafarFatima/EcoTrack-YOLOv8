import 'dart:async';
import 'network_status.dart';

/// Abstract service to monitor network connectivity changes reactively.
abstract class ConnectivityService {
  /// Stream that emits [NetworkStatus] whenever the connectivity changes.
  Stream<NetworkStatus> get connectivityStream;

  /// Returns the current status of the network.
  Future<NetworkStatus> get currentStatus;

  void dispose();
}

/// A placeholder implementation. In a production app, this would use 
/// the connectivity_plus package to listen to real system events.
class ConnectivityServiceImpl implements ConnectivityService {
  final _controller = StreamController<NetworkStatus>.broadcast();

  @override
  Stream<NetworkStatus> get connectivityStream => _controller.stream;

  @override
  Future<NetworkStatus> get currentStatus async => NetworkStatus.online;

  @override
  void dispose() {
    _controller.close();
  }
}
