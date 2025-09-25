import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/recaptcha_service.dart';
import '../../../../core/services/fcm_service.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/models/auth/signup_models.dart';
import 'package:dio/dio.dart';

class MobileVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();

  final RxString userMobile = ''.obs;
  final RxString tokenId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString otpError = ''.obs;
  final RxBool canResend = true.obs;
  final RxInt resendCountdown = 0.obs;
  final RxString currentOTP = ''.obs;

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
      userMobile.value = arguments['mobile'] ?? '';
      tokenId.value = arguments['tokenId'] ?? '';
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
    try {
      isLoading.value = true;

      final String recaptchaToken = await RecaptchaService().generateSignUpVerificationToken(action: 'SIGNUPVERIFICATION');
      final String platform = GetPlatform.isAndroid ? 'android' : 'ios';

      final request = VerifySignUpOtpRequest(
        tokenId: tokenId.value,
        mobileOtp: otp,
        reCaptchaToken: recaptchaToken,
        platform: platform,
      );

      Logger.api('VerifySignUpOtp request', endpoint: ApiEndpoints.verifySignUpOtp, data: request.toJson());

      final response = await ApiClient().postJson<Map<String, dynamic>>(
        ApiEndpoints.verifySignUpOtp,
        data: request.toJson(),
      );
      final data = response.data ?? <String, dynamic>{};
      Logger.network('VerifySignUpOtp response', url: ApiEndpoints.verifySignUpOtp, statusCode: response.statusCode);
      Logger.api('VerifySignUpOtp response body', endpoint: ApiEndpoints.verifySignUpOtp, data: data);
      // Handle non-2xx responses with JSON body
      if (response.statusCode != null && response.statusCode! >= 400) {
        final String err = (data['error'] ?? 'Verification failed').toString();
        otpError.value = err;
        return;
      }
      final parsed = VerifySignUpOtpResponse.fromJson(data);
      if (!parsed.success) {
        otpError.value = parsed.error.isNotEmpty ? parsed.error : 'Verification failed';
        return;
      }

      // Store login tokens for the second API call
      if (parsed.loginToken != null && parsed.loginTokenId != null) {
        await TokenStorageService().saveLoginTokens(parsed.loginToken!, parsed.loginTokenId!);
        
        // Make the second API call to verifyLogin
        await _verifyLogin(parsed.loginToken!, parsed.loginTokenId!);
      } else {
        otpError.value = 'Login tokens not received';
        return;
      }
    } on DioException catch (e, st) {
      Logger.e('Verify OTP API error', error: e, stackTrace: st);
      otpError.value = e.response?.data is Map<String, dynamic>
          ? ((e.response?.data as Map<String, dynamic>)['error'] ?? 'Network error').toString()
          : 'Network error';
    } catch (e, st) {
      Logger.e('Verify OTP unexpected error', error: e, stackTrace: st);
      otpError.value = 'Unexpected error';
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

  Future<void> _verifyLogin(String loginToken, String loginTokenId) async {
    try {
      // Generate FCM token
      // final String firebaseToken = await FCMService().getToken();
      String token;

      if (Platform.isAndroid) {
        token = await FirebaseMessaging.instance.getToken() ?? "";
      }else{
        token = await FirebaseMessaging.instance.getAPNSToken() ?? "";
      }
      final request = VerifyLoginRequest(
        loginToken: loginToken,
        loginTokenId: loginTokenId,
        firebaseToken: token,
      );

      Logger.api('VerifyLogin request', endpoint: ApiEndpoints.verifyLogin, data: request.toJson());

      final response = await ApiClient().postJson<Map<String, dynamic>>(
        ApiEndpoints.verifyLogin,
        data: request.toJson(),
      );

      final data = response.data ?? <String, dynamic>{};
      Logger.network('VerifyLogin response', url: ApiEndpoints.verifyLogin, statusCode: response.statusCode);
      Logger.api('VerifyLogin response body', endpoint: ApiEndpoints.verifyLogin, data: data);

      // Handle non-2xx responses with JSON body
      if (response.statusCode != null && response.statusCode! >= 400) {
        final String err = (data['error'] ?? 'Login verification failed').toString();
        otpError.value = err;
        return;
      }

      final parsed = VerifyLoginResponse.fromJson(data);
      if (!parsed.success) {
        otpError.value = parsed.error.isNotEmpty ? parsed.error : 'Login verification failed';
        return;
      }

      // Store JWT token
      if (parsed.token != null && parsed.token!.isNotEmpty) {
        await TokenStorageService().saveJWTToken(parsed.token!);
        Logger.i('JWT token saved successfully');
        
        // Navigate to main screen
        Get.offAllNamed('/main');
      } else {
        otpError.value = 'JWT token not received';
      }
    } on DioException catch (e, st) {
      Logger.e('VerifyLogin API error', error: e, stackTrace: st);
      otpError.value = e.response?.data is Map<String, dynamic>
          ? ((e.response?.data as Map<String, dynamic>)['error'] ?? 'Network error').toString()
          : 'Network error';
    } catch (e, st) {
      Logger.e('VerifyLogin unexpected error', error: e, stackTrace: st);
      otpError.value = 'Unexpected error during login verification';
    }
  }

  void navigateBack() {
    Get.back();
  }
}


