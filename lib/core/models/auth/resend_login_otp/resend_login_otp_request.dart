class ResendLoginOtpRequest {
  final String loginTokenId;
  final String reCaptchaToken;
  final String platform;

  const ResendLoginOtpRequest({
    required this.loginTokenId,
    required this.reCaptchaToken,
    required this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'loginTokenId': loginTokenId,
      'reCaptchaToken': reCaptchaToken,
      'platform': platform,
    };
  }

  @override
  String toString() {
    return 'ResendLoginOtpRequest{loginTokenId: $loginTokenId, platform: $platform}';
  }
}
