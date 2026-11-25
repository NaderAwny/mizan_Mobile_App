import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'token_local_data_source.dart';

@LazySingleton(as: TokenLocalDataSource)
class SecureTokenLocalDataSource implements TokenLocalDataSource {
  final FlutterSecureStorage _storage;
  SecureTokenLocalDataSource(this._storage);

  static const String _kAccess = 'access_token';
  static const String _kRefresh = 'refresh_token';
  static const String _kExpiresAt = 'expires_at';

  // كاش في الذاكرة للـ access token: بدل قراءة الـ Keystore/Keychain مع كل request.
  String? _accessCache;
  bool _accessLoaded = false;

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
  }) async {
    final DateTime expiry = DateTime.now().add(
      Duration(seconds: expiresInSeconds),
    );
    await Future.wait(<Future<void>>[
      _storage.write(key: _kAccess, value: accessToken),
      _storage.write(key: _kRefresh, value: refreshToken),
      _storage.write(key: _kExpiresAt, value: expiry.toIso8601String()),
    ]);
    _accessCache = accessToken;
    _accessLoaded = true;
  }

  @override
  Future<String?> getAccessToken() async {
    if (!_accessLoaded) {
      _accessCache = await _storage.read(key: _kAccess);
      _accessLoaded = true;
    }
    return _accessCache;
  }

  @override
  Future<String?> getRefreshToken() => _storage.read(key: _kRefresh);

  Future<DateTime?> _getExpiresAt() async {
    final String? raw = await _storage.read(key: _kExpiresAt);
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
    final String? r = await getRefreshToken();
    return r != null && r.isNotEmpty;
  }

  @override
  Future<bool> hasExpiredSession() async {
    final String? r = await getRefreshToken();
    if (r == null || r.isEmpty) return false; // مفيش حساب خالص
    final DateTime? expiresAt = await _getExpiresAt();
    if (expiresAt == null) return true;
    return !DateTime.now().isBefore(expiresAt); // فيه توكن بس منتهي
  }

  @override
  Future<void> clear() async {
    _accessCache = null;
    _accessLoaded = true;
    await Future.wait(<Future<void>>[
      _storage.delete(key: _kAccess),
      _storage.delete(key: _kRefresh),
      _storage.delete(key: _kExpiresAt),
    ]);
    _accessCache = null;
    _accessLoaded = true;
  }
}
