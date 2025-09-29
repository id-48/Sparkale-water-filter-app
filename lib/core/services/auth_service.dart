import 'dart:io';
import '../models/auth/login/login_request.dart';
import '../models/auth/login/login_response.dart';
import '../models/auth/verify_login/verify_login_request.dart';
import '../models/auth/verify_login/verify_login_response.dart';
import '../models/auth/register/signup_request.dart';
import '../models/auth/register/signup_response.dart';
import '../models/auth/verify_signup/verify_signup_request.dart';
import '../models/auth/verify_signup/verify_signup_response.dart';
import '../models/auth/verify_login_token/verify_login_token_request.dart';
import '../models/auth/verify_login_token/verify_login_token_response.dart';
import '../models/auth/logout/logout_response.dart';
import '../models/auth/profile/get_profile_response.dart';
import '../constants/api_endpoints.dart';
import '../utils/logger.dart';
import 'api_client.dart';
import 'token_storage_service.dart';
import 'fcm_service.dart';
import 'recaptcha_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiClient _apiClient = ApiClient();
  final TokenStorageService _tokenStorageService = TokenStorageService();
  final FCMService _fcmService = FCMService();
  final RecaptchaService _recaptchaService = RecaptchaService();

  /// Login API call with comprehensive logging
  Future<LoginResponse> login({
    required String mobileNo,
    required String reCaptchaToken,
    String platform = 'android',
  }) async {
    try {
      Logger.d('Starting login API call for mobile: $mobileNo');
      final loginRequest = LoginRequest(
        mobileNo: mobileNo,
        reCaptchaToken: reCaptchaToken,
        platform: platform,
      );

      Logger.api('Login Request prepared', endpoint: ApiEndpoints.login, data: loginRequest.toJson(),);

      final response = await _apiClient.postJson<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: loginRequest.toJson(),
      );

      Logger.d('Login API response received with status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData == null) {
          throw Exception('Empty response received from login API');
        }

        final loginResponse = LoginResponse.fromJson(responseData);
        
        Logger.d('Login response parsed successfully: $loginResponse');

        if (!loginResponse.success && loginResponse.error.isNotEmpty) {
          Logger.e('API responded with error: ${loginResponse.error}');
          throw Exception(loginResponse.error);
        }

        if (loginResponse.success && loginResponse.loginTokenId.isNotEmpty) {
          Logger.d('Saving login token ID: ${loginResponse.loginTokenId}');
          await _tokenStorageService.saveLoginTokens('', loginResponse.loginTokenId,
          );
          Logger.d('Login token ID saved successfully');
        } else {
          Logger.w('Login unsuccessful: ${loginResponse.error}');
        }

        return loginResponse;
      } else {
        String errorMessage = 'Login API failed with status: ${response.statusCode}';
        
        if (response.data is Map<String, dynamic>) {
          final errorData = response.data as Map<String, dynamic>;
          if (errorData.containsKey('error') && errorData['error'] != null) {
            errorMessage = errorData['error'].toString();
          }
        }
        
        Logger.e('Login API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e, st) {
      Logger.e('Login service failed', error: e, stackTrace: st);
      rethrow;
    }
  }


  /// Verify login OTP API call
  Future<VerifyLoginResponse> verifyLogin({
    required String loginTokenId,
    required String otp,
    String platform = 'android',
  }) async {
    try {
      Logger.d('Starting verify login API call');
      Logger.d('Generating FCM token');
      final firebaseToken = await _fcmService.getToken();
      Logger.d('FCM token generated successfully');
      Logger.d('Generating reCAPTCHA verification token');
      final reCaptchaToken = await _recaptchaService.generateLoginVerificationToken();
      Logger.d('reCAPTCHA verification token generated');
      final platformName = Platform.isAndroid ? 'android' : 'ios';
      Logger.d('Platform: $platformName');

      final verifyRequest = VerifyLoginRequest(
        loginTokenId: loginTokenId,
        otp: otp,
        firebaseToken: firebaseToken,
        reCaptchaToken: reCaptchaToken,
        platform: platformName,
      );

      Logger.api('Verify Login Request prepared', endpoint: ApiEndpoints.verifyLogin, data: verifyRequest.toJson(),);

      final response = await _apiClient.postJson<Map<String, dynamic>>(
        ApiEndpoints.verifyLogin,
        data: verifyRequest.toJson(),
      );

      Logger.d('Verify login API response received with status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData == null) {
          throw Exception('Empty response received from verify login API');
        }

        final verifyResponse = VerifyLoginResponse.fromJson(responseData);
        
        Logger.d('Verify login response parsed successfully: $verifyResponse');

        if (!verifyResponse.success && verifyResponse.error.isNotEmpty) {
          Logger.e('API responded with error: ${verifyResponse.error}');
          throw Exception(verifyResponse.error);
        }

        if (verifyResponse.success && verifyResponse.token.isNotEmpty) {
          Logger.d('Saving JWT token: ${verifyResponse.token.substring(0, 20)}...');
          await _tokenStorageService.saveJWTToken(verifyResponse.token);
          Logger.d('JWT token saved successfully');
        } else {
          Logger.w('Verify login unsuccessful: ${verifyResponse.error}');
        }

        return verifyResponse;
      } else {
        String errorMessage = 'Verify login API failed with status: ${response.statusCode}';
        
        if (response.data is Map<String, dynamic>) {
          final errorData = response.data as Map<String, dynamic>;
          if (errorData.containsKey('error') && errorData['error'] != null) {
            errorMessage = errorData['error'].toString();
          }
        }
        
        Logger.e('Verify login API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e, st) {
      Logger.e('Verify login service failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Signup API call
  Future<SignupResponse> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNo,
    required String countryCode,
    String image = '',
    String platform = 'android',
  }) async {
    try {
      Logger.d('Starting signup API call for: $firstName $lastName');
      Logger.d('Generating reCAPTCHA token for signup');
      final reCaptchaToken = await _recaptchaService.generateSignUpToken();
      Logger.d('reCAPTCHA token generated successfully');
      final platformName = Platform.isAndroid ? 'android' : 'ios';
      Logger.d('Platform: $platformName');

      final signupRequest = SignupRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobileNo: mobileNo,
        image: image,
        countryCode: countryCode,
        reCaptchaToken: reCaptchaToken,
        platform: platformName,
      );

      Logger.api('Signup Request prepared', endpoint: ApiEndpoints.signup, data: signupRequest.toJson(),);

      final response = await _apiClient.postJson<Map<String, dynamic>>(
        ApiEndpoints.signup,
        data: signupRequest.toJson(),
      );

      Logger.d('Signup API response received with status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData == null) {
          throw Exception('Empty response received from signup API');
        }

        final signupResponse = SignupResponse.fromJson(responseData);
        
        Logger.d('Signup response parsed successfully: $signupResponse');

        if (!signupResponse.success && signupResponse.error.isNotEmpty) {
          Logger.e('API responded with error: ${signupResponse.error}');
          throw Exception(signupResponse.error);
        }

        if (signupResponse.success && signupResponse.tokenId.isNotEmpty) {
          Logger.d('Saving signup token ID: ${signupResponse.tokenId}');
          await _tokenStorageService.saveLoginTokens('', signupResponse.tokenId,);
          Logger.d('Signup token ID saved successfully');
        } else {
          Logger.w('Signup unsuccessful: ${signupResponse.error}');
        }

        return signupResponse;
      } else {
        String errorMessage = 'Signup API failed with status: ${response.statusCode}';
        
        if (response.data is Map<String, dynamic>) {
          final errorData = response.data as Map<String, dynamic>;
          if (errorData.containsKey('error') && errorData['error'] != null) {
            errorMessage = errorData['error'].toString();
          }
        }
        
        Logger.e('Signup API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e, st) {
      Logger.e('Signup service failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Verify signup OTP API call
  Future<VerifySignupResponse> verifySignUpOtp({
    required String tokenId,
    required String mobileOtp,
    required String emailOtp,
    String platform = 'android',
  }) async {
    try {
      Logger.d('Starting verify signup OTP API call');
      Logger.d('Generating reCAPTCHA token for signup verification');
      final reCaptchaToken = await _recaptchaService.generateSignUpVerificationToken();
      Logger.d('reCAPTCHA verification token generated successfully');
      final platformName = Platform.isAndroid ? 'android' : 'ios';
      Logger.d('Platform: $platformName');

      final verifySignupRequest = VerifySignupRequest(
        tokenId: tokenId,
        mobileOtp: mobileOtp,
        emailOtp: emailOtp,
        reCaptchaToken: reCaptchaToken,
        platform: platformName,
      );

      Logger.api('Verify Signup Request prepared', endpoint: ApiEndpoints.verifySignUpOtp, data: verifySignupRequest.toJson(),);

      final response = await _apiClient.postJson<Map<String, dynamic>>(
        ApiEndpoints.verifySignUpOtp,
        data: verifySignupRequest.toJson(),
      );

      Logger.d('Verify signup API response received with status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData == null) {
          throw Exception('Empty response received from verify signup API');
        }

        final verifySignupResponse = VerifySignupResponse.fromJson(responseData);
        
        Logger.d('Verify signup response parsed successfully: $verifySignupResponse');

        if (!verifySignupResponse.success && verifySignupResponse.error.isNotEmpty) {
          Logger.e('API responded with error: ${verifySignupResponse.error}');
          throw Exception(verifySignupResponse.error);
        }

        if (verifySignupResponse.success) {
          if (verifySignupResponse.loginToken.isNotEmpty && verifySignupResponse.loginTokenId.isNotEmpty) {
            Logger.d('Calling verifyLoginWithToken after successful signup verification');
            try {
              final verifyLoginTokenResponse = await verifyLoginWithToken(
                loginToken: verifySignupResponse.loginToken,
                loginTokenId: verifySignupResponse.loginTokenId,
              );
              
              if (verifyLoginTokenResponse.success) {
                Logger.d('Login with token successful');
              } else {
                Logger.w('Login with token failed: ${verifyLoginTokenResponse.error}');
                throw Exception(verifyLoginTokenResponse.error);
              }
            } catch (e) {
              Logger.e('Error in verifyLoginWithToken: $e');
              rethrow;
            }
          } else {
            Logger.w('Missing loginToken or loginTokenId in signup response');
          }
        } else {
          Logger.w('Verify signup unsuccessful: ${verifySignupResponse.error}');
        }

        return verifySignupResponse;
      } else {
        String errorMessage = 'Verify signup API failed with status: ${response.statusCode}';
        
        if (response.data is Map<String, dynamic>) {
          final errorData = response.data as Map<String, dynamic>;
          if (errorData.containsKey('error') && errorData['error'] != null) {
            errorMessage = errorData['error'].toString();
          }
        }
        
        Logger.e('Verify signup API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e, st) {
      Logger.e('Verify signup service failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Verify login with token API call
  Future<VerifyLoginTokenResponse> verifyLoginWithToken({
    required String loginToken,
    required String loginTokenId,
  }) async {
    try {
      Logger.d('Starting verify login with token API call');
      Logger.d('Generating FCM token');
      final firebaseToken = await _fcmService.getToken();
      Logger.d('FCM token generated successfully');

      final verifyLoginTokenRequest = VerifyLoginTokenRequest(
        loginToken: loginToken,
        loginTokenId: loginTokenId,
        firebaseToken: firebaseToken,
      );

      Logger.api('Verify Login Token Request prepared', endpoint: ApiEndpoints.verifyLoginWithToken, data: verifyLoginTokenRequest.toJson(),);

      final response = await _apiClient.postJson<Map<String, dynamic>>(
        ApiEndpoints.verifyLoginWithToken,
        data: verifyLoginTokenRequest.toJson(),
      );

      Logger.d('Verify login with token API response received with status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData == null) {
          throw Exception('Empty response received from verify login with token API');
        }

        final verifyLoginTokenResponse = VerifyLoginTokenResponse.fromJson(responseData);
        
        Logger.d('Verify login with token response parsed successfully: $verifyLoginTokenResponse');

        if (!verifyLoginTokenResponse.success && verifyLoginTokenResponse.error.isNotEmpty) {
          Logger.e('API responded with error: ${verifyLoginTokenResponse.error}');
          throw Exception(verifyLoginTokenResponse.error);
        }

        if (verifyLoginTokenResponse.success && verifyLoginTokenResponse.token.isNotEmpty) {
          Logger.d('Saving JWT token: ${verifyLoginTokenResponse.token.substring(0, 20)}...');
          await _tokenStorageService.saveJWTToken(verifyLoginTokenResponse.token);
          Logger.d('JWT token saved successfully');
        } else {
          Logger.w('Verify login with token unsuccessful: ${verifyLoginTokenResponse.error}');
        }

        return verifyLoginTokenResponse;
      } else {
        String errorMessage = 'Verify login with token API failed with status: ${response.statusCode}';
        
        if (response.data is Map<String, dynamic>) {
          final errorData = response.data as Map<String, dynamic>;
          if (errorData.containsKey('error') && errorData['error'] != null) {
            errorMessage = errorData['error'].toString();
          }
        }
        
        Logger.e('Verify login with token API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e, st) {
      Logger.e('Verify login with token service failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Logout API call
  Future<LogoutResponse> logout() async {
    try {
      Logger.d('Starting logout API call');

      final jwtToken = await _tokenStorageService.getJWTToken();
      if (jwtToken == null || jwtToken.isEmpty) {
        throw Exception('JWT token not found. User may not be logged in.');
      }

      Logger.api('Logout Request prepared', endpoint: ApiEndpoints.logout,);

      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.logout,
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      Logger.d('Logout API response received with status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData == null) {
          throw Exception('Empty response received from logout API');
        }

        final logoutResponse = LogoutResponse.fromJson(responseData);
        
        Logger.d('Logout response parsed successfully: $logoutResponse');

        if (!logoutResponse.success && logoutResponse.error.isNotEmpty) {
          Logger.e('API responded with error: ${logoutResponse.error}');
          throw Exception(logoutResponse.error);
        }

        if (logoutResponse.success) {
          await _tokenStorageService.clearAllTokens();
          Logger.d('User logged out successfully and tokens cleared');
        }

        return logoutResponse;
      } else {
        String errorMessage = 'Logout API failed with status: ${response.statusCode}';
        
        if (response.data is Map<String, dynamic>) {
          final errorData = response.data as Map<String, dynamic>;
          if (errorData.containsKey('error') && errorData['error'] != null) {
            errorMessage = errorData['error'].toString();
          }
        }
        
        Logger.e('Logout API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e, st) {
      Logger.e('Logout service failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Get customer profile API call
  Future<GetProfileResponse> getCustomerProfile() async {
    try {
      Logger.d('Starting get customer profile API call');

      final jwtToken = await _tokenStorageService.getJWTToken();
      if (jwtToken == null || jwtToken.isEmpty) {
        throw Exception('JWT token not found. User may not be logged in.');
      }

      Logger.api('Get Customer Profile Request prepared', endpoint: ApiEndpoints.getCustomer,);

      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.getCustomer,
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      Logger.d('Get customer profile API response received with status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData == null) {
          throw Exception('Empty response received from get customer profile API');
        }

        final getProfileResponse = GetProfileResponse.fromJson(responseData);
        
        Logger.d('Get customer profile response parsed successfully: $getProfileResponse');

        if (!getProfileResponse.success && getProfileResponse.error.isNotEmpty) {
          Logger.e('API responded with error: ${getProfileResponse.error}');
          throw Exception(getProfileResponse.error);
        }

        Logger.d('Customer profile retrieved successfully: ${getProfileResponse.customer.fullName}');
        return getProfileResponse;
      } else {
        String errorMessage = 'Get customer profile API failed with status: ${response.statusCode}';
        
        if (response.data is Map<String, dynamic>) {
          final errorData = response.data as Map<String, dynamic>;
          if (errorData.containsKey('error') && errorData['error'] != null) {
            errorMessage = errorData['error'].toString();
          }
        }
        
        Logger.e('Get customer profile API error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e, st) {
      Logger.e('Get customer profile service failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Clear local tokens without API call (fallback)
  Future<void> clearLocalTokens() async {
    try {
      await _tokenStorageService.clearAllTokens();
      Logger.d('Local tokens cleared successfully');
    } catch (e, st) {
      Logger.e('Failed to clear local tokens', error: e, stackTrace: st);
    }
  }
}
