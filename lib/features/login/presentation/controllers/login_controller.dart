import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/logger.dart';

class LoginController extends GetxController {
  // Text controllers
  final TextEditingController emailController = TextEditingController();
  
  // Observable variables
  final RxBool isEmailInput = true.obs;
  final RxBool isLoading = false.obs;
  final Rx<CountryCode> selectedCountry = CountryCode.fromCountryCode('IN').obs;
  
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

  /// Select a country code
  void selectCountry(CountryCode country) {
    selectedCountry.value = country;
    Logger.d('Country selected: ${country.name} (${country.dialCode})');
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
      // For mobile number, validate with country code prefix
      final fullNumber = '${selectedCountry.value.dialCode}$input';
      return GetUtils.isPhoneNumber(fullNumber);
    }
  }
  
  /// Perform the actual OTP sending logic
  void _performSendOtp() async {
    try {
      isLoading.value = true;
      
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      final contactInfo = isEmailInput.value 
          ? emailController.text.trim()
          : '${selectedCountry.value.dialCode}${emailController.text.trim()}';
      Logger.d('OTP sent successfully to: $contactInfo');
      
      // Show success message
      Get.snackbar(
        AppStrings.success,
        AppStrings.otpSentSuccessfully,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      // Navigate to OTP verification screen
      Get.toNamed('/email-verification', arguments: {
        'email': emailController.text.trim(),
      });
      
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
      
      // Navigate to home screen after successful login
      Get.offAllNamed('/main');
      
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
    Get.toNamed('/register');
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
