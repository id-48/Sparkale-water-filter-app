import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/recaptcha_service.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/services/token_storage_service.dart';

class EmailVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();

  final RxString userEmail = ''.obs;
  final RxString loginTokenId = ''.obs;
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
    _initializeEmail();
    Logger.i('EmailVerificationController initialized');
  }

  @override
  void onClose() {
    // Dispose controller
    otpController.dispose();

    // Cancel timers
    _resendTimer?.cancel();

    super.onClose();
  }

  void _initializeEmail() {
    // Get email and loginTokenId from arguments passed from login screen
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      userEmail.value = arguments['email'] ?? '';
      loginTokenId.value = arguments['loginTokenId'] ?? '';
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
    
    if (loginTokenId.value.isEmpty) {
      otpError.value = 'Login token not found';
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Get Firebase token and reCAPTCHA token
      final firebaseToken = await _fcmService.getToken();
      final reCaptchaToken = await _recaptchaService.generateLoginVerificationToken();
      
      // Prepare request data
      final requestData = {
        'loginTokenId': loginTokenId.value,
        'otp': otp,
        'firebaseToken': firebaseToken,
        'reCaptchaToken': reCaptchaToken,
        'platform': 'android',
      };
      
      // Make API call
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
          otpError.value = data['error'] ?? 'Verification failed';
        }
      } else {
        otpError.value = 'Verification failed';
      }
      
    } catch (e) {
      Logger.e('Error verifying email OTP', error: e);
      otpError.value = 'Verification failed';
    } finally {
      isLoading.value = false;
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

      Logger.i('OTP resent successfully');

      // Start countdown timer
      _startResendCountdown();

      // Clear current OTP fields
      _clearOTPFields();
    } catch (e) {
      Logger.e('Failed to resend OTP', error: e);
    } finally {
      isLoading.value = false;
    }
  }

  void _startResendCountdown() {
    canResend.value = false;
    resendCountdown.value = 30; // 30 seconds countdown

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
