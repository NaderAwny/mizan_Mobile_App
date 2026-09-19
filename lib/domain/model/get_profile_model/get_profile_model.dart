class GetProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String userType;
  final bool isActive;
  final GetProfileShopModel? shop;
  GetProfileModel(
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.isActive,
    this.shop,
  );
}

class GetProfileShopModel {
  final String? id;
  final String? shopName;
  final String? address;
  GetProfileShopModel({this.id, this.shopName, this.address});
}
