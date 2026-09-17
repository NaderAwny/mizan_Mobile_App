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
  final List<Completer<void>> _pendingRequests = [];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenLocalDataSource.getAccessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) return handler.next(err);

    if (_isRefreshing) {
      final completer = Completer<void>();
      _pendingRequests.add(completer);
      try {
        await completer.future;
        final freshToken = await tokenLocalDataSource.getAccessToken();
        return handler.resolve(await _retry(err.requestOptions, freshToken));
      } catch (_) {
        return handler.next(err);
      }
    }

    _isRefreshing = true;
    try {
      final refreshToken = await tokenLocalDataSource.getRefreshToken();
      if (refreshToken == null) {
        throw DioException(
          requestOptions: err.requestOptions,
          error: 'No refresh token',
        );
      }
      final response = await authDio.post(
        '/api/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );
      final data = response.data['data'];
      final newAccessToken = data['token'];
      await tokenLocalDataSource.saveSession(
        accessToken: newAccessToken,
        refreshToken: data['refreshToken'],
        expiresInSeconds: data['expiresInSeconds'],
      );
      for (final c in _pendingRequests) {
        c.complete();
      }
      _pendingRequests.clear();
      // لازم نبعت التوكن الجديد مع الريتراي، مش هيدر الطلب الأصلي اللي
      // لسه فيه Bearer التوكن القديم المنتهي.
      return handler.resolve(await _retry(err.requestOptions, newAccessToken));
    } catch (e) {
      for (final c in _pendingRequests) {
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

  Future<Response> _retry(RequestOptions o, String? newAccessToken) {
    final headers = Map<String, dynamic>.from(o.headers);
    if (newAccessToken != null) {
      headers['Authorization'] = 'Bearer $newAccessToken';
    }
    final options = Options(method: o.method, headers: headers);
    return authDio.request(
      o.path,
      data: o.data,
      queryParameters: o.queryParameters,
      options: options,
    );
  }
}
