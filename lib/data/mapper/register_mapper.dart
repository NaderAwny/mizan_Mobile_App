import 'package:mizan/app/constants.dart';
import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/register_responses/register_responses.dart';
import 'package:mizan/domain/model/register_model.dart';

extension RegisterResponseMapper on RegisterDataResponse {
  RegisterModel toDomain() {
    return RegisterModel(
      registerResponse?.otpSent?.orFalse() ?? Constants.isFalse,
      registerResponse?.expiresInSeconds?.orZero() ?? Constants.zero,
      registerResponse?.message?.orEmpty() ?? Constants.empty,
    );
  }
}
