import 'network_info.dart';
import 'network_result.dart';
import 'network_service.dart';
import 'base_network_service.dart';
import 'network_exception.dart';

class NetworkServiceImpl extends BaseNetworkService implements NetworkService {
  NetworkServiceImpl({required NetworkInfo networkInfo}) : super(networkInfo);

  @override
  Future<NetworkResult<T>> call<T>(Future<T> Function() action) async {
    try {
      final result = await runWithExceptionHandling(action);
      return NetworkSuccess(result);
    } on NetworkException catch (e) {
      return NetworkFailure(e);
    } catch (e) {
      return NetworkFailure(NetworkException(message: e.toString()));
    }
  }

  @override
  Stream<T> stream<T>(Stream<T> stream) {
    return mapStreamException(stream);
  }
}
