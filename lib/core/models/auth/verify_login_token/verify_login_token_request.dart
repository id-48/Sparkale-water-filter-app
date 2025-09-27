import 'dart:convert';

VerifyLoginTokenRequest verifyLoginTokenRequestFromJson(String str) => VerifyLoginTokenRequest.fromJson(json.decode(str));

String verifyLoginTokenRequestToJson(VerifyLoginTokenRequest data) => json.encode(data.toJson());

class VerifyLoginTokenRequest {
  String loginToken;
  String loginTokenId;
  String firebaseToken;

  VerifyLoginTokenRequest({
    required this.loginToken,
    required this.loginTokenId,
    required this.firebaseToken,
  });

  factory VerifyLoginTokenRequest.fromJson(Map<String, dynamic> json) => VerifyLoginTokenRequest(
    loginToken: json["loginToken"],
    loginTokenId: json["loginTokenId"],
    firebaseToken: json["firebaseToken"],
  );

  Map<String, dynamic> toJson() => {
    "loginToken": loginToken,
    "loginTokenId": loginTokenId,
    "firebaseToken": firebaseToken,
  };
}
