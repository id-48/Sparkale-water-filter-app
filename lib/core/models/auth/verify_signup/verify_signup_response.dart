import 'dart:convert';

VerifySignupResponse verifySignupResponseFromJson(String str) => VerifySignupResponse.fromJson(json.decode(str));

String verifySignupResponseToJson(VerifySignupResponse data) => json.encode(data.toJson());

class VerifySignupResponse {
  bool success;
  String error;
  String reasonCode;
  String loginToken;
  String loginTokenId;

  VerifySignupResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
    required this.loginToken,
    required this.loginTokenId,
  });

  factory VerifySignupResponse.fromJson(Map<String, dynamic> json) => VerifySignupResponse(
    success: json["success"],
    error: json["error"],
    reasonCode: json["reasonCode"],
    loginToken: json["loginToken"],
    loginTokenId: json["loginTokenId"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "reasonCode": reasonCode,
    "loginToken": loginToken,
    "loginTokenId": loginTokenId,
  };
}
