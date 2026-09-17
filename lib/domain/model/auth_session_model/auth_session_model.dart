class AuthSession {
  String token;
  String refreshToken;
  int expiresInSeconds;
  bool isNewUser;
  String userId;
  String firstName;
  String lastName;
  String email;
  String userType; // "customer" | "shop_owner"
  String shopName;

  AuthSession(
    this.token,
    this.refreshToken,
    this.expiresInSeconds,
    this.isNewUser,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.shopName,
  );
}
