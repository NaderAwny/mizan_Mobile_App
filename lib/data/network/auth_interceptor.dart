import 'dart:async';
import 'package:dio/dio.dart';
import 'package:mizan/app/session_manager.dart';
import '../local/token_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  final TokenLocalDataSource tokenLocalDataSource;
  final Dio authDio;
  final SessionManager sessionManager;

  AuthInterceptor({
    required this.tokenLocalDataSource,
    required this.authDio,
    required this.sessionManager,
  });

  bool _isRefreshing = false;
  final List<Completer<void>> _pendingRequests = <Completer<void>>[];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = await tokenLocalDataSource.getAccessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) return handler.next(err);

    if (_isRefreshing) {
      final Completer<void> completer = Completer<void>();
      _pendingRequests.add(completer);
      try {
        await completer.future;
        final String? freshToken = await tokenLocalDataSource.getAccessToken();
        return handler.resolve(await _retry(err.requestOptions, freshToken));
      } catch (_) {
        return handler.next(err);
      }
    }

    _isRefreshing = true;
    try {
      final String? refreshToken = await tokenLocalDataSource.getRefreshToken();
      if (refreshToken == null) {
        throw DioException(
          requestOptions: err.requestOptions,
          error: 'No refresh token',
        );
      }
      final Response<Map<String, dynamic>> response = await authDio.post(
        '/api/auth/refresh-token',
        data: <String, String>{'refreshToken': refreshToken},
      );
      final Map<String, dynamic> body =
          (response.data!['data'] as Map<String, dynamic>);
      final String newAccessToken = body['token'] as String;
      await tokenLocalDataSource.saveSession(
        accessToken: newAccessToken,
        refreshToken: body['refreshToken'] as String,
        expiresInSeconds: body['expiresInSeconds'] as int,
      );
      for (final Completer<void> c in _pendingRequests) {
        c.complete();
      }
      _pendingRequests.clear();
      // لازم نبعت التوكن الجديد مع الريتراي، مش هيدر الطلب الأصلي اللي
      // لسه فيه Bearer التوكن القديم المنتهي.
      return handler.resolve(await _retry(err.requestOptions, newAccessToken));
    } catch (e) {
      for (final Completer<void> c in _pendingRequests) {
        c.completeError(e);
      }
      _pendingRequests.clear();
      await tokenLocalDataSource.clear();
      sessionManager.notifySessionExpired();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions o, String? newAccessToken) {
    final Map<String, dynamic> headers = Map<String, dynamic>.from(o.headers);
    if (newAccessToken != null) {
      headers['Authorization'] = 'Bearer $newAccessToken';
    }
    final Options options = Options(method: o.method, headers: headers);
    final dynamic data =
        o.data is FormData ? (o.data as FormData).clone() : o.data;
    return authDio.request<dynamic>(
      o.path,
      data: data,
      queryParameters: o.queryParameters,
      options: options,
    );
  }
}
