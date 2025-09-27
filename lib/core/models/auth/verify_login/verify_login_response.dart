import 'dart:convert';

VerifyLoginResponse verifyLoginResponseFromJson(String str) => VerifyLoginResponse.fromJson(json.decode(str));

String verifyLoginResponseToJson(VerifyLoginResponse data) => json.encode(data.toJson());

class VerifyLoginResponse {
  bool success;
  String error;
  String reasonCode;
  String token;

  VerifyLoginResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
    required this.token,
  });

  factory VerifyLoginResponse.fromJson(Map<String, dynamic> json) => VerifyLoginResponse(
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
