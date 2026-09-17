import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'token_local_data_source.dart';

@LazySingleton(as: TokenLocalDataSource)
class SecureTokenLocalDataSource implements TokenLocalDataSource {
  final FlutterSecureStorage _storage;
  SecureTokenLocalDataSource(this._storage);

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kExpiresAt = 'expires_at';

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
  }) async {
    final expiry = DateTime.now().add(Duration(seconds: expiresInSeconds));
    await Future.wait([
      _storage.write(key: _kAccess, value: accessToken),
      _storage.write(key: _kRefresh, value: refreshToken),
      _storage.write(key: _kExpiresAt, value: expiry.toIso8601String()),
    ]);
  }

  @override
  Future<String?> getAccessToken() => _storage.read(key: _kAccess);

  @override
  Future<String?> getRefreshToken() => _storage.read(key: _kRefresh);

  Future<DateTime?> _getExpiresAt() async {
    final raw = await _storage.read(key: _kExpiresAt);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  @override
  Future<bool> hasValidSession() async {
    // مهم: _kExpiresAt بيتخزن من expiresInSeconds بتاع الـ ACCESS token (30 دقيقة)
    // مش عمر الـ refresh token (30 يوم)، فمينفعش نستخدمه هنا كمقياس لصلاحية
    // الجلسة كلها — ده كان سبب الـ logout التلقائي كل نص ساعة.
    // وجود الـ refresh token نفسه كافي؛ لو هو فعلاً منتهي أو متسحب من السيرفر،
    // أول ريكوست هيرجع 401 والـ AuthInterceptor هيحاول يجدده ولو فشل هيعمل
    // logout فعلي وقتها (session_manager.notifySessionExpired).
    final r = await getRefreshToken();
    return r != null && r.isNotEmpty;
  }

  @override
  Future<bool> hasExpiredSession() async {
    final r = await getRefreshToken();
    if (r == null || r.isEmpty) return false; // مفيش حساب خالص
    final expiresAt = await _getExpiresAt();
    if (expiresAt == null) return true;
    return !DateTime.now().isBefore(expiresAt); // فيه توكن بس منتهي
  }

  @override
  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _kAccess),
      _storage.delete(key: _kRefresh),
      _storage.delete(key: _kExpiresAt),
    ]);
  }
}
