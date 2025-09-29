import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/clarity_config.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/api_error_handler.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/services/clarity_service.dart';

class EmailVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();

  final RxString userEmail = ''.obs;
  final RxString loginTokenId = ''.obs;
  final RxString tokenId = ''.obs;
  final RxString signupTokenId = ''.obs;
  final RxString mobileNumber = ''.obs;
  final RxString mobileOtp = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool canResend = true.obs;
  RxString flow = ''.obs;
  final RxInt resendCountdown = 0.obs;
  final RxString currentOTP = ''.obs;
  Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;

  final AuthService _authService = AuthService();
  final TokenStorageService _tokenStorageService = TokenStorageService();

  Timer? _resendTimer;

  @override
  void onInit() {
    super.onInit();
    ClarityService.to.trackScreenView(ClarityConfig.screenEmailVerification);
    _initializeEmail();

    flow.value = arguments?["flow"] ?? "";
    Logger.i('EmailVerificationController initialized');
  }

  @override
  void onClose() {
    otpController.dispose();
    _resendTimer?.cancel();

    super.onClose();
  }

  void _initializeEmail() {
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      userEmail.value = arguments['email'] ?? '';
      loginTokenId.value = arguments['loginTokenId'] ?? '';
      tokenId.value = arguments['tokenId'] ?? '';
      signupTokenId.value = arguments['tokenId'] ?? '';
      mobileNumber.value = arguments['mobile'] ?? '';
      mobileOtp.value = arguments['mobileOtp'] ?? '';
    }
  }

  void onOTPChanged(String value) {
    currentOTP.value = value;
  }

  void onOTPCompleted(String value) {
    if (value.length == 6) {
      _verifyOTP(value);
    }
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
      Logger.d('Starting email OTP verification for: ${userEmail.value}');

      if (flow.value == 'register') {
        await _verifySignupEmailOTP(otp);
      } else {
        await _verifyLoginEmailOTP(otp);
      }
      
    } catch (e, st) {
      Logger.e('Error verifying email OTP', error: e, stackTrace: st);
      
      final errorMessage = ApiErrorHandler.handleError(e);
      ToastService.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _verifyLoginEmailOTP(String otp) async {
    String loginTokenIdValue = loginTokenId.value;
    if (loginTokenIdValue.isEmpty) {
      final tokens = await _tokenStorageService.getLoginTokens();
      loginTokenIdValue = tokens['loginTokenId'] ?? '';
    }

    if (loginTokenIdValue.isEmpty) {
      ToastService.error('Login token not found. Please login again.');
      return;
    }

    final platform = Platform.isAndroid ? 'android' : 'ios';
    Logger.d('Platform: $platform');
    Logger.d('Making verify login API call');
    final verifyResponse = await _authService.verifyLogin(
      loginTokenId: loginTokenIdValue,
      otp: otp,
      platform: platform,
    );

    if (verifyResponse.success) {
      Logger.d('Email OTP verification successful');
      ToastService.success('Email verification successful');
      
      ClarityService.to.trackAuthEvent(ClarityConfig.eventOtpVerified, properties: {
        'type': 'email',
        'flow': 'login'
      });
      
      ClarityService.to.trackNavigation(ClarityConfig.screenEmailVerification, ClarityConfig.screenHome);
      Get.offAllNamed('/main');
    } else {
      Logger.w('Email OTP verification failed: ${verifyResponse.error}');
      ClarityService.to.trackAuthEvent(ClarityConfig.eventOtpFailed, properties: {
        'type': 'email',
        'flow': 'login',
        'error': verifyResponse.error
      });
      final errorMessage = verifyResponse.error.isNotEmpty 
          ? verifyResponse.error 
          : 'OTP verification failed. Please try again.';
      ToastService.error(errorMessage);
    }
  }

  Future<void> _verifySignupEmailOTP(String otp) async {
    if (signupTokenId.value.isEmpty) {
      ToastService.error('Signup token not found. Please try again.');
      return;
    }

    final platform = Platform.isAndroid ? 'android' : 'ios';
    Logger.d('Platform: $platform');

    String mobileOtpToSend = mobileOtp.value;
    String emailOtpToSend = otp;

    if (mobileOtpToSend.isNotEmpty) {
      Logger.d('Making verify signup API call with both mobile and email OTPs');
    } else {
      Logger.d('Making verify signup API call for email-only');
    }

    final verifyResponse = await _authService.verifySignUpOtp(
      tokenId: signupTokenId.value,
      mobileOtp: mobileOtpToSend,
      emailOtp: emailOtpToSend,
      platform: platform,
    );

    if (verifyResponse.success) {
      Logger.d('Email OTP verification successful');
      ToastService.success('Login Successful');
      Get.offAllNamed('/main');
    } else {
      Logger.w('Email OTP verification failed: ${verifyResponse.error}');
      final errorMessage = verifyResponse.error.isNotEmpty 
          ? verifyResponse.error 
          : 'OTP verification failed. Please try again.';
      ToastService.error(errorMessage);
    }
  }

  Future<void> verifyOTP() async {
    final otp = _getOTP();
    if (otp.length == 6) {
      ClarityService.to.trackUserAction(ClarityConfig.actionSendOtp, properties: {
        'status': 'verify_attempt',
        'screen': 'email_verification',
        'flow': flow.value
      });
      await _verifyOTP(otp);
    } else {
      ClarityService.to.trackUserAction(ClarityConfig.actionSendOtp, properties: {
        'status': 'incomplete_otp',
        'screen': 'email_verification'
      });
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
      
      ClarityService.to.trackUserAction(ClarityConfig.actionSendOtp, properties: {
        'status': 'resend_attempt',
        'screen': 'email_verification',
        'flow': flow.value
      });

      await Future.delayed(const Duration(seconds: 1));

      Logger.i('OTP resent successfully');

      _startResendCountdown();

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
