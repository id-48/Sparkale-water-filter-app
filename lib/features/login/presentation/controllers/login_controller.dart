import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/constants/clarity_config.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/api_error_handler.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/recaptcha_service.dart';
import '../../../../core/services/clarity_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  
  final RxBool isEmailInput = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<CountryCode> selectedCountry = CountryCode.fromCountryCode('IN').obs;
  
  GlobalKey<FormState> get formKey => _formKey;
  late final GlobalKey<FormState> _formKey;

  final AuthService _authService = AuthService();
  final RecaptchaService _recaptchaService = RecaptchaService();
  

  @override
  void onInit() {
    super.onInit();
    _formKey = GlobalKey<FormState>(debugLabel: 'LoginForm_${DateTime.now().millisecondsSinceEpoch}');
    ClarityService.to.trackScreenView(ClarityConfig.screenLogin);
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
    ClarityService.to.trackUserAction(ClarityConfig.actionToggleInputType, properties: {
      'input_type': isEmailInput.value ? 'email' : 'mobile'
    });
  }

  void selectCountry(CountryCode country) {
    selectedCountry.value = country;
    Logger.d('Country selected: ${country.name} (${country.dialCode})');
    ClarityService.to.trackUserAction(ClarityConfig.actionSelectCountry, properties: {
      'country_name': country.name,
      'country_code': country.dialCode,
    });
  }
  
  Future<void> sendOtp() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      ClarityService.to.trackUserAction(ClarityConfig.actionSendOtp, properties: {'status': 'validation_failed'});
      return;
    }
    
    try {
      isLoading.value = true;
      final inputValue = emailController.text.trim();
      
      ClarityService.to.trackUserAction(ClarityConfig.actionSendOtp, properties: {
        'input_type': isEmailInput.value ? 'email' : 'mobile',
        'country_code': selectedCountry.value.dialCode,
        'status': 'attempt'
      });
      
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
        
        ClarityService.to.trackAuthEvent(ClarityConfig.eventOtpSent, properties: {
          'input_type': isEmailInput.value ? 'email' : 'mobile',
        });

        if (isEmailInput.value) {
          ClarityService.to.trackNavigation(ClarityConfig.screenLogin, ClarityConfig.screenEmailVerification);
          Get.toNamed('/email-verification', arguments: {
            'email': inputValue,
            'flow': 'login'
          });
        } else {
          ClarityService.to.trackNavigation(ClarityConfig.screenLogin, ClarityConfig.screenMobileVerification);
          Get.toNamed('/mobile-verification', arguments: {
            'mobileNo': inputValue,
            'countryCode': selectedCountry.value.dialCode ?? "",
            'flow': 'login'
          });
        }
      } else {
        Logger.w('Login API call failed: ${loginResponse.error}');
        ClarityService.to.trackAuthEvent(ClarityConfig.eventOtpFailed, properties: {
          'error': loginResponse.error,
          'input_type': isEmailInput.value ? 'email' : 'mobile',
        });
        final errorMessage = loginResponse.error.isNotEmpty
            ? loginResponse.error 
            : 'Login failed. Please try again.';
        _showErrorToast(errorMessage);
      }
      
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleError(e);
      ClarityService.to.trackError(ClarityConfig.errorApi, errorMessage, properties: {
        'input_type': isEmailInput.value ? 'email' : 'mobile',
        'action': 'send_otp'
      });
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
    ClarityService.to.trackNavigation(ClarityConfig.screenLogin, ClarityConfig.screenRegister);
    Get.toNamed('/register');
  }
  
  void _showErrorToast(String message) {
    ToastService.error(message);
  }
  
  String? validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return isEmailInput.value ? 'Email is required' : 'Phone number is required';
    }
    
    if (isEmailInput.value) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Please enter a valid email address';
      }
    } else {
      if (value.trim().length != 10) {
        return 'Phone number must be 10 digits';
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
        return 'Phone number must contain only digits';
      }
    }
    return null;
  }
}
