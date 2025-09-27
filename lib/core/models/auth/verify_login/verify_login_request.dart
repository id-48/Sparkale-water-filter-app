class VerifyLoginRequest {
  final String loginTokenId;
  final String otp;
  final String firebaseToken;
  final String reCaptchaToken;
  final String platform;

  const VerifyLoginRequest({
    required this.loginTokenId,
    required this.otp,
    required this.firebaseToken,
    required this.reCaptchaToken,
    required this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'loginTokenId': loginTokenId,
      'otp': otp,
      'firebaseToken': firebaseToken,
      'reCaptchaToken': reCaptchaToken,
      'platform': platform,
    };
  }

  @override
  String toString() {
    return 'VerifyLoginRequest{loginTokenId: $loginTokenId, platform: $platform}';
  }
}
