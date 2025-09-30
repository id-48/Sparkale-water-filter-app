import 'dart:convert';

ResendSignUpOtpResponse resendSignUpOtpResponseFromJson(String str) => ResendSignUpOtpResponse.fromJson(json.decode(str));

String resendSignUpOtpResponseToJson(ResendSignUpOtpResponse data) => json.encode(data.toJson());

class ResendSignUpOtpResponse {
  String tokenId;
  String reCaptchaToken;
  String platform;

  ResendSignUpOtpResponse({
    required this.tokenId,
    required this.reCaptchaToken,
    required this.platform,
  });

  factory ResendSignUpOtpResponse.fromJson(Map<String, dynamic> json) => ResendSignUpOtpResponse(
    tokenId: json["tokenId"] ?? "",
    reCaptchaToken: json["reCaptchaToken"] ?? "",
    platform: json["platform"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "tokenId": tokenId,
    "reCaptchaToken": reCaptchaToken,
    "platform": platform,
  };
}
