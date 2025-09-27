class LoginRequest {
  final String mobileNo;
  final String reCaptchaToken;
  final String platform;

  const LoginRequest({
    required this.mobileNo,
    required this.reCaptchaToken,
    required this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobileNo': mobileNo,
      'reCaptchaToken': reCaptchaToken,
      'platform': platform,
    };
  }

  @override
  String toString() {
    return 'LoginRequest{mobileNo: $mobileNo, platform: $platform}';
  }
}