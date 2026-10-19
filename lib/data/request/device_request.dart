class RegisterDeviceRequest {
  final String token;
  final String platform;
  final String? deviceId;

  const RegisterDeviceRequest({
    required this.token,
    this.platform = 'Android',
    this.deviceId,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'token': token,
    'platform': platform,
    if (deviceId != null) 'deviceId': deviceId,
  };
}

class UnregisterDeviceRequest {
  final String token;

  const UnregisterDeviceRequest({
    required this.token,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
    'token': token,
  };
}
