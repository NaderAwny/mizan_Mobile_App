import 'package:mizan/app/constants.dart';
import 'package:mizan/app/extensions.dart';
import 'package:mizan/data/response/get_profile_responses/get_profile_responses.dart';
import 'package:mizan/domain/model/get_profile_model/get_profile_model.dart';

extension GetProfileMapper on GetProfileDataResponse {
  GetProfileModel toDomain() {
    return GetProfileModel(
      data?.id?.orEmpty() ?? Constants.empty,
      data?.firstName?.orEmpty() ?? Constants.empty,
      data?.lastName?.orEmpty() ?? Constants.empty,
      data?.email?.orEmpty() ?? Constants.empty,
      data?.userType?.orEmpty() ?? Constants.empty,
      data?.isActive?.orFalse() ?? Constants.isFalse,
      GetProfileShopModel(
        id: data?.shop?.id?.orEmpty() ?? Constants.empty,
        shopName: data?.shop?.shopName?.orEmpty() ?? Constants.empty,
        address: data?.shop?.address?.orEmpty() ?? Constants.empty,
      ),
    );
  }
}
