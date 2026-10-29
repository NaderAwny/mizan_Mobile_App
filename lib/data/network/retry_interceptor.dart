import 'package:dio/dio.dart';

/// إعادة محاولة تلقائية لطلبات GET بس (آمنة، مفيهاش تكرار عمليات مالية)
/// في حالات الفشل العابر: connectionError أو 502/503/504 (السيرفر بيصحى/بيعيد تشغيل).
/// أقصى محاولتين بتأخير 0.5s ثم 1s، فالمستخدم مش بيشوف شاشة الخطأ لأي هفوة لحظية.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio, {this.maxRetries = 2});

  final Dio _dio;
  final int maxRetries;
  static const String _key = '__retry_count';

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final RequestOptions o = err.requestOptions;
    final int attempt = (o.extra[_key] as int?) ?? 0;
    if (o.method.toUpperCase() != 'GET' ||
        attempt >= maxRetries ||
        !_shouldRetry(err)) {
      return handler.next(err);
    }
    await Future<void>.delayed(Duration(milliseconds: 500 * (attempt + 1)));
    o.extra[_key] = attempt + 1;
    try {
      final Response<dynamic> response = await _dio.fetch<dynamic>(o);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException e) {
    if (e.type == DioExceptionType.connectionError) return true;
    final int? status = e.response?.statusCode;
    return status == 502 || status == 503 || status == 504;
  }
}
