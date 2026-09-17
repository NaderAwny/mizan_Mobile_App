import 'package:mizan/app/constants.dart';
import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/auth_session_responses/auth_session_responses.dart';
import 'package:mizan/domain/model/auth_session_model/auth_session_model.dart';

extension AuthSessionResponseMapper on AuthSessionData {
  AuthSession toDomain() => AuthSession(
        token?.orEmpty() ?? Constants.empty,
        refreshToken?.orEmpty() ?? Constants.empty,
        expiresInSeconds?.orZero() ?? Constants.zero,
        isNewUser?.orFalse() ?? Constants.isFalse,
        userId?.orEmpty() ?? Constants.empty,
        firstName?.orEmpty() ?? Constants.empty,
        lastName?.orEmpty() ?? Constants.empty,
        email?.orEmpty() ?? Constants.empty,
        userType?.orEmpty() ?? Constants.empty,
        shopName?.orEmpty() ?? Constants.empty,
      );
}
