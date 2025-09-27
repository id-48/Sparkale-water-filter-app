import 'dart:convert';

SignupResponse signupResponseFromJson(String str) => SignupResponse.fromJson(json.decode(str));

String signupResponseToJson(SignupResponse data) => json.encode(data.toJson());

class SignupResponse {
  bool success;
  String error;
  String reasonCode;
  String tokenId;
  bool verifyMobileNoOTP;
  bool verifyEmailOTP;

  SignupResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
    required this.tokenId,
    required this.verifyMobileNoOTP,
    required this.verifyEmailOTP,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
    success: json["success"],
    error: json["error"],
    reasonCode: json["reasonCode"],
    tokenId: json["tokenId"],
    verifyMobileNoOTP: json["verifyMobileNoOTP"],
    verifyEmailOTP: json["verifyEmailOTP"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "reasonCode": reasonCode,
    "tokenId": tokenId,
    "verifyMobileNoOTP": verifyMobileNoOTP,
    "verifyEmailOTP": verifyEmailOTP,
  };
}