import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/api_error_handler.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/recaptcha_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  
  final RxBool isEmailInput = true.obs;
  final RxBool isLoading = false.obs;
  final Rx<CountryCode> selectedCountry = CountryCode.fromCountryCode('IN').obs;

  final AuthService _authService = AuthService();
  final RecaptchaService _recaptchaService = RecaptchaService();
  

  @override
  void onInit() {
    super.onInit();
  }
  
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
  
  void toggleInputType() {
    isEmailInput.value = !isEmailInput.value;
    emailController.clear();
    Logger.d('Input type toggled to: ${isEmailInput.value ? "Email" : "Mobile"}');
  }

  void selectCountry(CountryCode country) {
    selectedCountry.value = country;
    Logger.d('Country selected: ${country.name} (${country.dialCode})');
  }
  
  Future<void> sendOtp() async {
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
    
    try {
      isLoading.value = true;
      final inputValue = emailController.text.trim();
      
      final reCaptchaToken = await _recaptchaService.generateLoginToken();
      final platform = Platform.isAndroid ? 'android' : 'ios';

      String mobileNoForApi;
      if (isEmailInput.value) {
        mobileNoForApi = inputValue;
      } else {
        mobileNoForApi = inputValue;
      }

      Logger.d('Making login API call with mobileNo: $mobileNoForApi');
      final loginResponse = await _authService.login(
        mobileNo: mobileNoForApi,
        reCaptchaToken: reCaptchaToken,
        platform: platform,
      );

      if (loginResponse.success) {
        Logger.d('Login API call successful');
        ToastService.success('Code Send Successfully');

        if (isEmailInput.value) {
          Get.toNamed('/email-verification', arguments: {
            'email': inputValue,
            'flow': 'login'
          });
        } else {
          Get.toNamed('/mobile-verification', arguments: {
            'mobileNo': inputValue,
            'countryCode': selectedCountry.value.dialCode ?? "",
            'flow': 'login'
          });
        }
      } else {
        Logger.w('Login API call failed: ${loginResponse.error}');
        final errorMessage = loginResponse.error.isNotEmpty
            ? loginResponse.error 
            : 'Login failed. Please try again.';
        _showErrorToast(errorMessage);
      }
      
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleError(e);
      _showErrorToast(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
  
  bool _isValidInput() {
    final input = emailController.text.trim();
    
    if (isEmailInput.value) {
      return GetUtils.isEmail(input);
    } else {
      final fullNumber = '${selectedCountry.value.dialCode}$input';
      return GetUtils.isPhoneNumber(fullNumber);
    }
  }
  
  void navigateToSignUp() {
    Logger.d('Navigate to Sign Up');
    Get.toNamed('/register');
  }
  
  void _showErrorToast(String message) {
    ToastService.error(message);
  }
}
