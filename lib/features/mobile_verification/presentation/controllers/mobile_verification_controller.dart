import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/api_error_handler.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/token_storage_service.dart';

class MobileVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();

  final RxString userMobile = ''.obs;
  final RxString tokenId = ''.obs;
  final RxString signupTokenId = ''.obs;
  final RxBool needsEmailVerification = false.obs;
  final RxString userEmail = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool canResend = true.obs;
  final RxInt resendCountdown = 0.obs;
  final RxString currentOTP = ''.obs;
  RxString flow = ''.obs;
  Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;



  // Services for API calls
  final AuthService _authService = AuthService();
  final TokenStorageService _tokenStorageService = TokenStorageService();

  Timer? _resendTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeMobile();
    flow.value = arguments?["flow"] ?? "";
    print("flow==== $flow");
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
      signupTokenId.value = arguments['tokenId'] ?? '';
      needsEmailVerification.value = arguments['needsEmailVerification'] == true;
      userEmail.value = arguments['email'] ?? '';
    }

    if (userMobile.value.isEmpty) {
      userMobile.value = '+00******0000';
    }
  }

  void onOTPChanged(String value) {
    currentOTP.value = value;
  }


  String _getOTP() {
    return currentOTP.value;
  }

  Future<void> _verifyOTP(String otp) async {
    if (otp.length != 6) {
      ToastService.error('Please enter a valid 6-digit OTP');
      return;
    }
    
    try {
      isLoading.value = true;
      Logger.d('Starting mobile OTP verification for: ${userMobile.value}');

      // Check if this is a signup flow or login flow
      if (flow.value == 'register') {
        await _verifySignupOTP(otp);
      } else {
        await _verifyLoginOTP(otp);
      }
      
    } catch (e, st) {
      Logger.e('Error verifying mobile OTP', error: e, stackTrace: st);
      
      // Use centralized error handler
      final errorMessage = ApiErrorHandler.handleError(e);
      ToastService.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _verifyLoginOTP(String otp) async {
    // Get loginTokenId from storage if available
    String loginTokenId = tokenId.value;
    if (loginTokenId.isEmpty) {
      // Try to get it from storage
      final tokens = await _tokenStorageService.getLoginTokens();
      loginTokenId = tokens['loginTokenId'] ?? '';
    }

    if (loginTokenId.isEmpty) {
      ToastService.error('Login token not found. Please login again.');
      return;
    }

    // Determine platform
    final platform = Platform.isAndroid ? 'android' : 'ios';
    Logger.d('Platform: $platform');

    // Make verify login API call
    Logger.d('Making verify login API call');
    final verifyResponse = await _authService.verifyLogin(
      loginTokenId: loginTokenId,
      otp: otp,
      platform: platform,
    );

    if (verifyResponse.success) {
      Logger.d('Mobile OTP verification successful');
      ToastService.success('Login Successful.');
      
      // Navigate based on verification step
      _checkNextVerificationStep();
    } else {
      Logger.w('Mobile OTP verification failed: ${verifyResponse.error}');
      final errorMessage = verifyResponse.error.isNotEmpty 
          ? verifyResponse.error 
          : 'OTP verification failed. Please try again.';
      ToastService.error(errorMessage);
    }
  }

  Future<void> _verifySignupOTP(String otp) async {
    if (signupTokenId.value.isEmpty) {
      ToastService.error('Signup token not found. Please try again.');
      return;
    }

    // Determine platform
    final platform = Platform.isAndroid ? 'android' : 'ios';
    Logger.d('Platform: $platform');

    // Check if email verification is also needed
    if (needsEmailVerification.value && userEmail.value.isNotEmpty) {
      // Both mobile and email verification needed - store mobile OTP and navigate to email verification
      // We'll verify both OTPs together in email verification
      Logger.d('Mobile OTP verified, navigating to email verification');
      ToastService.success('Mobile OTP verified');
      
      // Navigate to email verification with mobile OTP stored
      Get.toNamed('/email-verification', arguments: {
        'email': userEmail.value,
        'mobile': userMobile.value,
        'tokenId': signupTokenId.value,
        'mobileOtp': otp, // Pass the mobile OTP to email verification
        'flow': 'register'
      });
    } else {
      // Mobile-only verification
      Logger.d('Making verify signup API call for mobile-only');
      final verifyResponse = await _authService.verifySignUpOtp(
        tokenId: signupTokenId.value,
        mobileOtp: otp,
        emailOtp: '', // Empty for mobile-only verification
        platform: platform,
      );

      if (verifyResponse.success) {
        Logger.d('Mobile OTP verification successful');
        ToastService.success('Login Successful');
        
        // Navigate to main screen
        Get.offAllNamed('/main');
      } else {
        Logger.w('Mobile OTP verification failed: ${verifyResponse.error}');
        final errorMessage = verifyResponse.error.isNotEmpty 
            ? verifyResponse.error 
            : 'OTP verification failed. Please try again.';
        ToastService.error(errorMessage);
      }
    }
  }





  void _checkNextVerificationStep() {
    if (flow.value == 'register') {
      // For signup flow, check if email verification is needed
      if (needsEmailVerification.value && userEmail.value.isNotEmpty) {
        Get.toNamed('/email-verification', arguments: {
          'email': userEmail.value,
          'mobile': userMobile.value,
          'tokenId': signupTokenId.value,
          'flow': 'register'
        });
      } else {
        // Mobile-only signup verification completed
        Get.offAllNamed('/main');
      }
    } else {
      // For login flow
      if (needsEmailVerification.value && userEmail.value.isNotEmpty) {
        Get.toNamed('/email-verification', arguments: {
          'email': userEmail.value,
          'mobile': userMobile.value,
          'flow': 'login'
        });
      } else {
        Get.offAllNamed('/main');
      }
    }
  }

  Future<void> verifyOTP() async {
    final otp = _getOTP();
    if (otp.length == 6) {
      await _verifyOTP(otp);
    } else {
      ToastService.error('Please enter the complete OTP');
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


