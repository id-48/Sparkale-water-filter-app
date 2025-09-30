import 'dart:convert';

ResendLoginOtpResponse resendLoginOtpResponseFromJson(String str) => ResendLoginOtpResponse.fromJson(json.decode(str));

String resendLoginOtpResponseToJson(ResendLoginOtpResponse data) => json.encode(data.toJson());

class ResendLoginOtpResponse {
  bool success;
  String error;
  String reasonCode;
  String loginTokenId;

  ResendLoginOtpResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
    required this.loginTokenId,
  });

  factory ResendLoginOtpResponse.fromJson(Map<String, dynamic> json) => ResendLoginOtpResponse(
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
