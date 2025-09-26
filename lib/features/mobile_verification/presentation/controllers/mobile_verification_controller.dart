import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/recaptcha_service.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/models/auth/signup_models.dart';

class MobileVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();

  final RxString userMobile = ''.obs;
  final RxString tokenId = ''.obs;
  final RxBool needsEmailVerification = false.obs;
  final RxString userEmail = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString otpError = ''.obs;
  final RxBool canResend = true.obs;
  final RxInt resendCountdown = 0.obs;
  final RxString currentOTP = ''.obs;
  
  // Services
  final ApiClient _apiClient = ApiClient();
  final RecaptchaService _recaptchaService = RecaptchaService();
  final FCMService _fcmService = FCMService();
  final TokenStorageService _tokenStorage = TokenStorageService();

  Timer? _resendTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeMobile();
    Logger.i('MobileVerificationController initialized');
  }

  @override
  void onClose() {
    otpController.dispose();
    _resendTimer?.cancel();
    super.onClose();
  }

  void _initializeMobile() {
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      userMobile.value = arguments['mobileNo'] ?? arguments['mobile'] ?? '';
      tokenId.value = arguments['loginTokenId'] ?? arguments['tokenId'] ?? '';
      needsEmailVerification.value = arguments['needsEmailVerification'] == true;
      userEmail.value = arguments['email'] ?? '';
    }

    if (userMobile.value.isEmpty) {
      userMobile.value = '+00******0000';
    }
  }

  void onOTPChanged(String value) {
    currentOTP.value = value;
    otpError.value = '';
  }

  void onOTPCompleted(String value) {
    otpError.value = '';
    if (value.length == 6) {
      _verifyOTP(value);
    }
  }

  String _getOTP() {
    return currentOTP.value;
  }

  Future<void> _verifyOTP(String otp) async {
    if (otp.length != 6) {
      otpError.value = 'Please enter a valid 6-digit OTP';
      return;
    }
    
    if (tokenId.value.isEmpty) {
      otpError.value = 'Token not found';
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Check if this is a signup flow by looking at current route
      final bool isSignUpFlow = Get.currentRoute.contains('mobile-verification');
      
      if (isSignUpFlow) {
        // Use verifySignUpOtp API for signup flow
        await _verifySignUpOTP(otp);
      } else {
        // Use verifyLogin API for login flow
        await _verifyLoginOTP(otp);
      }
      
    } catch (e) {
      Logger.e('Error verifying mobile OTP', error: e);
      otpError.value = 'Verification failed';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _verifySignUpOTP(String otp) async {
    try {
      final reCaptchaToken = await _recaptchaService.generateSignUpToken();
      
      final VerifySignUpOtpRequest request = VerifySignUpOtpRequest(
        tokenId: tokenId.value,
        mobileOtp: otp,
        reCaptchaToken: reCaptchaToken,
        platform: 'android',
      );
      
      Logger.api('Verify SignUp OTP request', endpoint: ApiEndpoints.verifySignUpOtp, data: request.toJson());

      final response = await _apiClient.postJson<Map<String, dynamic>>(
        ApiEndpoints.verifySignUpOtp,
        data: request.toJson(),
      );

      final data = response.data ?? <String, dynamic>{};
      Logger.api('Verify SignUp OTP response', endpoint: ApiEndpoints.verifySignUpOtp, data: data);

      final verifySignUpOtpResponse = VerifySignUpOtpResponse.fromJson(data);
      
      if (!verifySignUpOtpResponse.success) {
        String errorMessage = verifySignUpOtpResponse.error.isNotEmpty ? verifySignUpOtpResponse.error : 'Verification failed';
        if (verifySignUpOtpResponse.reasonCode.isNotEmpty) {
          errorMessage = verifySignUpOtpResponse.reasonCode;
        }
        ToastService.error(errorMessage);
        otpError.value = errorMessage;
        return;
      }

      // If successful and it returns loginToken/loginTokenId, call verifyLogin
      if (verifySignUpOtpResponse.loginToken != null && verifySignUpOtpResponse.loginTokenId != null) {
        await _verifyLoginWithTokens(verifySignUpOtpResponse.loginToken!, verifySignUpOtpResponse.loginTokenId!);
      } else {
        // Show success and navigate to next verification or check if email verification needed
        // Based on signup response, determine next step
        ToastService.success('Mobile verification successful');
        // Check if we need to navigate to email verification or proceed to main
        _checkNextVerificationStep();
      }
      
    } catch (e) {
      Logger.e('Error verifying signup OTP', error: e);
      otpError.value = 'Verification failed';
    }
  }

  Future<void> _verifyLoginOTP(String otp) async {
    try {
      final firebaseToken = await _fcmService.getToken();
      final reCaptchaToken = await _recaptchaService.generateLoginVerificationToken();
      
      final requestData = {
        'loginTokenId': tokenId.value,
        'otp': otp,
        'firebaseToken': firebaseToken,
        'reCaptchaToken': reCaptchaToken,
        'platform': 'android',
      };
      
      final response = await _apiClient.postJson<Map<String, dynamic>>(
        ApiEndpoints.verifyLogin,
        data: requestData,
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        final success = data['success'] ?? false;
        final token = data['token'];
        
        if (success && token != null) {
          await _tokenStorage.saveJWTToken(token);
          Get.offAllNamed('/main');
        } else {
          final errorMessage = data['reasonCode']?.toString() ?? data['error']?.toString() ?? 'Verification failed';
          otpError.value = errorMessage;
          ToastService.error(errorMessage);
        }
      } else {
        otpError.value = 'Verification failed';
        ToastService.error('Verification failed');
      }
    } catch (e) {
      Logger.e('Error verifying login OTP', error: e);
      otpError.value = 'Verification failed';
    }
  }

  Future<void> _verifyLoginWithTokens(String loginToken, String loginTokenId) async {
    try {
      final firebaseToken = await _fcmService.getToken();
      
      final requestData = {
        'loginToken': loginToken,
        'loginTokenId': loginTokenId,
        'firebaseToken': firebaseToken,
      };
      
      final response = await _apiClient.postJson<Map<String, dynamic>>(
        ApiEndpoints.verifyLogin,
        data: requestData,
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        final success = data['success'] ?? false;
        final token = data['token'];
        
        if (success && token != null) {
          await _tokenStorage.saveJWTToken(token);
          Get.offAllNamed('/main');
        } else {
          final errorMessage = data['reasonCode']?.toString() ?? data['error']?.toString() ?? 'Login verification failed';
          ToastService.error(errorMessage);
          otpError.value = errorMessage;
        }
      } else {
        ToastService.error('Login verification failed');
        otpError.value = 'Login verification failed';
      }
    } catch (e) {
      Logger.e('Error verifying login with tokens', error: e);
      otpError.value = 'Login verification failed';
      ToastService.error('Login verification failed');
    }
  }

  void _checkNextVerificationStep() {
    // Check if we need to navigate to email verification
    if (needsEmailVerification.value && userEmail.value.isNotEmpty) {
      // Navigate to email verification
      Get.offNamed('/email-verification', arguments: {
        'email': userEmail.value,
        'tokenId': tokenId.value,
      });
    } else {
      Get.offAllNamed('/main');
    }
  }

  Future<void> verifyOTP() async {
    final otp = _getOTP();
    if (otp.length == 6) {
      await _verifyOTP(otp);
    } else {
      otpError.value = 'Please enter the complete OTP';
    }
  }

  void _clearOTPFields() {
    currentOTP.value = '';
    otpController.clear();
  }

  Future<void> resendOTP() async {
    if (!canResend.value) return;

    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      Logger.i('Mobile OTP resent successfully');
      _startResendCountdown();
      _clearOTPFields();
    } catch (e) {
      Logger.e('Failed to resend mobile OTP', error: e);
    } finally {
      isLoading.value = false;
    }
  }

  void _startResendCountdown() {
    canResend.value = false;
    resendCountdown.value = 30;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendCountdown.value--;
      if (resendCountdown.value <= 0) {
        canResend.value = true;
        timer.cancel();
      }
    });
  }


  void navigateBack() {
    Get.back();
  }
}


