import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  /// false (الافتراضي): مفيش ping قبل كل request. أي فشل شبكة بيوصل من Dio
  /// كـ DioExceptionType.connectionError والـ ErrorHandler بيحوله لـ
  /// NO_INTERNET_CONNECTION. غيّرها لـ true بس عشان تعمل مقارنة A/B بالـ ms.
  static const bool kProbeBeforeRequest = false;

  final InternetConnectionChecker _internetConnectionChecker;
  NetworkInfoImpl(this._internetConnectionChecker);

  @override
  Future<bool> get isConnected async {
    if (!kProbeBeforeRequest) return true;
    return await _internetConnectionChecker.hasConnection;
  }
}
