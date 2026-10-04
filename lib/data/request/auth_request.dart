class VerifyOtpRequest {
  final String email;
  final String code;

  const VerifyOtpRequest({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'email': email,
    'code': code,
  };
}

class SelectUserTypeRequest {
  final String userType;
  final String? shopName;
  final String? address;

  const SelectUserTypeRequest({
    required this.userType,
    this.shopName,
    this.address,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'userType': userType,
    if (shopName != null) 'shopName': shopName,
    if (address != null) 'address': address,
  };
}

class LogoutRequest {
  final String refreshToken;

  const LogoutRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'refreshToken': refreshToken,
  };
}
