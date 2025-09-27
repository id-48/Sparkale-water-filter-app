import 'dart:convert';

VerifySignupRequest verifySignupRequestFromJson(String str) => VerifySignupRequest.fromJson(json.decode(str));

String verifySignupRequestToJson(VerifySignupRequest data) => json.encode(data.toJson());

class VerifySignupRequest {
  String tokenId;
  String mobileOtp;
  String emailOtp;
  String reCaptchaToken;
  String platform;

  VerifySignupRequest({
    required this.tokenId,
    required this.mobileOtp,
    required this.emailOtp,
    required this.reCaptchaToken,
    required this.platform,
  });

  factory VerifySignupRequest.fromJson(Map<String, dynamic> json) => VerifySignupRequest(
    tokenId: json["tokenId"],
    mobileOtp: json["mobileOtp"],
    emailOtp: json["emailOtp"],
    reCaptchaToken: json["reCaptchaToken"],
    platform: json["platform"],
  );

  Map<String, dynamic> toJson() => {
    "tokenId": tokenId,
    "mobileOtp": mobileOtp,
    "emailOtp": emailOtp,
    "reCaptchaToken": reCaptchaToken,
    "platform": platform,
  };
}
