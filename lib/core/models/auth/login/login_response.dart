import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool success;
  String error;
  String reasonCode;
  String loginTokenId;

  LoginResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
    required this.loginTokenId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    success: json["success"],
    error: json["error"],
    reasonCode: json["reasonCode"],
    loginTokenId: json["loginTokenId"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "reasonCode": reasonCode,
    "loginTokenId": loginTokenId,
  };
}
