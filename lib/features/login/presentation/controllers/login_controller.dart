import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/toast_service.dart';

class LoginController extends GetxController {
  // Text controllers
  final TextEditingController emailController = TextEditingController();
  
  // Observable variables
  final RxBool isEmailInput = true.obs;
  final RxBool isLoading = false.obs;
  final Rx<CountryCode> selectedCountry = CountryCode.fromCountryCode('IN').obs;
  
  // No services needed for API calls
  
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
      _showErrorToast(
        isEmailInput.value 
            ? AppStrings.pleaseEnterEmail 
            : AppStrings.pleaseEnterMobileNumber
      );
      return;
    }
    
    if (!_isValidInput()) {
      _showErrorToast(
        isEmailInput.value 
            ? AppStrings.pleaseEnterValidEmail 
            : AppStrings.pleaseEnterValidMobileNumber
      );
      return;
    }
    
    // Input validation passed, could add local logic here
    Logger.d('OTP send request for: ${emailController.text.trim()}');
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
  
  /// Navigate to sign up screen
  void navigateToSignUp() {
    Logger.d('Navigate to Sign Up');
    Get.toNamed('/register');
  }
  
  /// Show error toast
  void _showErrorToast(String message) {
    ToastService.error(message);
  }
}
