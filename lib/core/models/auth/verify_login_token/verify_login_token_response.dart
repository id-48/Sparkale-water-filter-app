import 'dart:convert';

VerifyLoginTokenResponse verifyLoginTokenResponseFromJson(String str) => VerifyLoginTokenResponse.fromJson(json.decode(str));

String verifyLoginTokenResponseToJson(VerifyLoginTokenResponse data) => json.encode(data.toJson());

class VerifyLoginTokenResponse {
  bool success;
  String error;
  String reasonCode;
  String token;

  VerifyLoginTokenResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
    required this.token,
  });

  factory VerifyLoginTokenResponse.fromJson(Map<String, dynamic> json) => VerifyLoginTokenResponse(
    success: json["success"],
    error: json["error"],
    reasonCode: json["reasonCode"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "reasonCode": reasonCode,
    "token": token,
  };
}
