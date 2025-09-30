class ResendSignUpOtpRequest {
  final String tokenId;
  final String reCaptchaToken;
  final String platform;

  const ResendSignUpOtpRequest({
    required this.tokenId,
    required this.reCaptchaToken,
    required this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'tokenId': tokenId,
      'reCaptchaToken': reCaptchaToken,
      'platform': platform,
    };
  }

  @override
  String toString() {
    return 'ResendSignUpOtpRequest{tokenId: $tokenId, platform: $platform}';
  }
}
