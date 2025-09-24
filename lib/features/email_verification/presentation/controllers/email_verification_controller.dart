import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/logger.dart';

class EmailVerificationController extends GetxController {
  // OTP Controller for otp_pin_field
  final TextEditingController otpController = TextEditingController();

  // Observable Variables
  final RxString userEmail = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString otpError = ''.obs;
  final RxBool canResend = true.obs;
  final RxInt resendCountdown = 0.obs;
  final RxString currentOTP = ''.obs;

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
    // Get email from arguments passed from register screen
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      userEmail.value = arguments['email'] ?? '';
    }

    if (userEmail.value.isEmpty) {
      // Fallback to a default email for demo
      userEmail.value = 'olivia@untitledui.com';
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
     // Navigate to main
     Get.offAllNamed('/main');
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
