import 'dart:convert';

LogoutResponse logoutResponseFromJson(String str) => LogoutResponse.fromJson(json.decode(str));

String logoutResponseToJson(LogoutResponse data) => json.encode(data.toJson());

class LogoutResponse {
  bool success;
  String error;
  String reasonCode;

  LogoutResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) => LogoutResponse(
    success: json["success"],
    error: json["error"],
    reasonCode: json["reasonCode"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "reasonCode": reasonCode,
  };
}
