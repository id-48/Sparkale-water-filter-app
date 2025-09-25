class SignupRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String mobileNo;
  final String? imageBase64;
  final String countryCode; // without leading +
  final String reCaptchaToken;
  final String platform; // 'android' | 'ios'

  SignupRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNo,
    required this.imageBase64,
    required this.countryCode,
    required this.reCaptchaToken,
    required this.platform,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'mobileNo': mobileNo,
        'image': imageBase64,
        'countryCode': countryCode,
        'reCaptchaToken': reCaptchaToken,
        'platform': platform,
      };
}

class SignupResponse {
  final bool success;
  final String error;
  final String reasonCode;
  final String? tokenId;
  final bool verifyMobileNoOTP;
  final bool verifyEmailOTP;

  SignupResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
    required this.tokenId,
    required this.verifyMobileNoOTP,
    required this.verifyEmailOTP,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
        success: json['success'] == true,
        error: (json['error'] ?? '').toString(),
        reasonCode: (json['reasonCode'] ?? '').toString(),
        tokenId: json['tokenId']?.toString(),
        verifyMobileNoOTP: json['verifyMobileNoOTP'] == true,
        verifyEmailOTP: json['verifyEmailOTP'] == true,
      );
}

class VerifySignUpOtpRequest {
  final String tokenId;
  final String mobileOtp;
  final String reCaptchaToken;
  final String platform;

  VerifySignUpOtpRequest({
    required this.tokenId,
    required this.mobileOtp,
    required this.reCaptchaToken,
    required this.platform,
  });

  Map<String, dynamic> toJson() => {
        'tokenId': tokenId,
        'mobileOtp': mobileOtp,
        'reCaptchaToken': reCaptchaToken,
        'platform': platform,
      };
}

class VerifySignUpOtpResponse {
  final bool success;
  final String error;
  final String reasonCode;
  final String? loginToken;
  final String? loginTokenId;

  VerifySignUpOtpResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
    required this.loginToken,
    required this.loginTokenId,
  });

  factory VerifySignUpOtpResponse.fromJson(Map<String, dynamic> json) =>
      VerifySignUpOtpResponse(
        success: json['success'] == true,
        error: (json['error'] ?? '').toString(),
        reasonCode: (json['reasonCode'] ?? '').toString(),
        loginToken: json['loginToken']?.toString(),
        loginTokenId: json['loginTokenId']?.toString(),
      );
}

class VerifyLoginRequest {
  final String loginToken;
  final String loginTokenId;
  final String firebaseToken;

  VerifyLoginRequest({
    required this.loginToken,
    required this.loginTokenId,
    required this.firebaseToken,
  });

  Map<String, dynamic> toJson() => {
        'loginToken': loginToken,
        'loginTokenId': loginTokenId,
        'firebaseToken': firebaseToken,
      };
}

class VerifyLoginResponse {
  final bool success;
  final String error;
  final String reasonCode;
  final String? token;

  VerifyLoginResponse({
    required this.success,
    required this.error,
    required this.reasonCode,
    required this.token,
  });

  factory VerifyLoginResponse.fromJson(Map<String, dynamic> json) =>
      VerifyLoginResponse(
        success: json['success'] == true,
        error: (json['error'] ?? '').toString(),
        reasonCode: (json['reasonCode'] ?? '').toString(),
        token: json['token']?.toString(),
      );
}


