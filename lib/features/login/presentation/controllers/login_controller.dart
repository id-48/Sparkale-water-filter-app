import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/logger.dart';

class LoginController extends GetxController {
  // Text controllers
  final TextEditingController emailController = TextEditingController();
  
  // Observable variables
  final RxBool isEmailInput = true.obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    Logger.d('LoginController initialized');
  }
  
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
  
  /// Toggle between email and mobile number input
  void toggleInputType() {
    isEmailInput.value = !isEmailInput.value;
    emailController.clear();
    Logger.d('Input type toggled to: ${isEmailInput.value ? "Email" : "Mobile"}');
  }
  
  /// Send OTP to the provided email or mobile number
  void sendOtp() {
    if (emailController.text.trim().isEmpty) {
      _showErrorSnackBar(
        isEmailInput.value 
            ? AppStrings.pleaseEnterEmail 
            : AppStrings.pleaseEnterMobileNumber
      );
      return;
    }
    
    if (!_isValidInput()) {
      _showErrorSnackBar(
        isEmailInput.value 
            ? AppStrings.pleaseEnterValidEmail 
            : AppStrings.pleaseEnterValidMobileNumber
      );
      return;
    }
    
    _performSendOtp();
  }
  
  /// Validate email or mobile number input
  bool _isValidInput() {
    final input = emailController.text.trim();
    
    if (isEmailInput.value) {
      return GetUtils.isEmail(input);
    } else {
      return GetUtils.isPhoneNumber(input);
    }
  }
  
  /// Perform the actual OTP sending logic
  void _performSendOtp() async {
    try {
      isLoading.value = true;
      
      // TODO: Implement actual OTP sending API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      Logger.d('OTP sent successfully to: ${emailController.text.trim()}');
      
      // Show success message
      Get.snackbar(
        AppStrings.success,
        AppStrings.otpSentSuccessfully,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      // TODO: Navigate to OTP verification screen
      // Get.toNamed(AppPages.otpVerification);
      
    } catch (e) {
      Logger.e('Error sending OTP', error: e);
      _showErrorSnackBar(AppStrings.errorSendingOtp);
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Sign in with Google
  void signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      // TODO: Implement Google Sign-In
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      Logger.d('Google Sign-In initiated');
      
      // Show success message
      Get.snackbar(
        AppStrings.success,
        AppStrings.googleSignInSuccess,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      // TODO: Navigate to home screen after successful login
      // Get.offAllNamed(AppPages.home);
      
    } catch (e) {
      Logger.e('Error with Google Sign-In', error: e);
      _showErrorSnackBar(AppStrings.googleSignInError);
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Navigate to sign up screen
  void navigateToSignUp() {
    Logger.d('Navigate to Sign Up');
    // TODO: Navigate to sign up screen
    // Get.toNamed(AppPages.signUp);
  }
  
  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    Get.snackbar(
      AppStrings.error,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
