abstract class TokenLocalDataSource {
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required int expiresInSeconds,
  });
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();

  /// فيه توكن ولسه جوه فترة صلاحية الـ refresh token. ده اللي يقرر لو المستخدم
  /// يدخل Home من الـ Splash مباشرة من غير تسجيل دخول.
  Future<bool> hasValidSession();

  /// فيه (أو كان فيه) refresh token بس هو منتهي — حساب موجود بس محتاج دخول تاني.
  Future<bool> hasExpiredSession();

  Future<void> clear();
}

