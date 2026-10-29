import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// بيقيس زمن كل request بالـ ms (من قبل قراءة التوكن لحد الرد) للمقارنة مع Postman.
/// بيتفعل في debug/profile بس. استخدم --profile للأرقام الحقيقية.
class TimingInterceptor extends Interceptor {
  static const String _key = '__stopwatch';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_key] = Stopwatch()..start();
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _log(response.requestOptions, response.statusCode);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final int? code = err.response?.statusCode;
    _log(
      err.requestOptions,
      code == 401 ? '401 (refresh + retry follows)' : (code ?? err.type.name),
    );
    handler.next(err);
  }

  void _log(RequestOptions o, Object? status) {
    final Object? sw = o.extra[_key];
    if (sw is Stopwatch) {
      debugPrint('⏱ ${o.method} ${o.path} -> $status in ${sw.elapsedMilliseconds} ms');
    }
  }
}
