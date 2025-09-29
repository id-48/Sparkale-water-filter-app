import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/constants/clarity_config.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/api_error_handler.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/clarity_service.dart';

class RegisterController extends GetxController {

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  
  GlobalKey<FormState> get formKey => _formKey;
  late final GlobalKey<FormState> _formKey;
  
  final RxBool isTermsAccepted = false.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCountryCode = '+91'.obs;
  final RxString selectedCountryFlag = '🇮🇳'.obs;
  
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    _formKey = GlobalKey<FormState>(debugLabel: 'RegisterForm_${DateTime.now().millisecondsSinceEpoch}');
    ClarityService.to.trackScreenView(ClarityConfig.screenRegister);
    Logger.i('RegisterController initialized with default country code: ${selectedCountryCode.value}');
  }
  
  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
  
  void onCountryChanged(CountryCode countryCode) {
    final String newCountryCode = countryCode.dialCode ?? '+91';
    final String newCountryFlag = countryCode.flagUri ?? '🇮🇳';
    
    selectedCountryCode.value = newCountryCode;
    selectedCountryFlag.value = newCountryFlag;
    
    Logger.d('Country changed to: ${countryCode.name} (${countryCode.dialCode}) - Code: $newCountryCode, Flag: $newCountryFlag');
    Logger.i('Selected country code updated to: ${selectedCountryCode.value}');
  }
  
  void toggleTermsAcceptance() {
    isTermsAccepted.value = !isTermsAccepted.value;
    Logger.d('Terms acceptance toggled: ${isTermsAccepted.value}');
  }

  void navigateToSignUp() {
    Logger.d('Navigate to Sign Up');
    Get.toNamed('/login');
  }

  
  Future<void> registerUser() async {
    if (isLoading.value) return;
    
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      ClarityService.to.trackUserAction(ClarityConfig.actionSendOtp, properties: {'status': 'validation_failed', 'screen': 'register'});
      return;
    }
    
    if (!isTermsAccepted.value) {
      ToastService.error('Please accept Terms & Conditions');
      ClarityService.to.trackUserAction(ClarityConfig.actionSendOtp, properties: {'status': 'terms_not_accepted', 'screen': 'register'});
      return;
    }

    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String mobile = phoneController.text.trim();

    try {
      isLoading.value = true;
      
      ClarityService.to.trackUserAction(ClarityConfig.actionSendOtp, properties: {
        'status': 'attempt',
        'screen': 'register',
        'has_email': email.isNotEmpty,
        'has_mobile': mobile.isNotEmpty
      });
      
      final String countryCode = selectedCountryCode.value.replaceAll('+', '');
      Logger.d('Starting registration process for: $firstName $lastName');

      String mobileNoForApi = '';
      if (mobile.isNotEmpty) {
        mobileNoForApi = mobile;
      } else if (email.isNotEmpty) {
        mobileNoForApi = '';
      }

      // Determine platform
      final platform = Platform.isAndroid ? 'android' : 'ios';
      Logger.d('Platform: $platform');

      // Make signup API call
      Logger.d('Making signup API call');
      final signupResponse = await _authService.signup(
        firstName: firstName,
        lastName: lastName,
        email: email.isNotEmpty ? email : '',
        mobileNo: mobileNoForApi,
        countryCode: countryCode,
        platform: platform,
      );

      if (signupResponse.success) {
        Logger.d('Code Send Successfully');
        ToastService.success('Code Send Successfully');
        
        ClarityService.to.trackAuthEvent(ClarityConfig.eventSignupSuccess, properties: {
          'has_email': email.isNotEmpty,
          'has_mobile': mobile.isNotEmpty
        });

        if (signupResponse.verifyMobileNoOTP && signupResponse.verifyEmailOTP) {
          ClarityService.to.trackNavigation(ClarityConfig.screenRegister, ClarityConfig.screenMobileVerification);
          Get.toNamed('/mobile-verification', arguments: {
            'mobile': mobile,
            'countryCode': countryCode,
            'needsEmailVerification': true,
            'email': email,
            'tokenId': signupResponse.tokenId,
            'flow': 'register'
          });
        } else if (signupResponse.verifyMobileNoOTP && mobile.isNotEmpty) {
          ClarityService.to.trackNavigation(ClarityConfig.screenRegister, ClarityConfig.screenMobileVerification);
          Get.toNamed('/mobile-verification', arguments: {
            'mobile': mobile,
            'countryCode': countryCode,
            'tokenId': signupResponse.tokenId,
            'flow': 'register'
          });
        } else if (signupResponse.verifyEmailOTP && email.isNotEmpty) {
          ClarityService.to.trackNavigation(ClarityConfig.screenRegister, ClarityConfig.screenEmailVerification);
          Get.toNamed('/email-verification', arguments: {
            'email': email,
            'tokenId': signupResponse.tokenId,
            'flow': 'register'
          });
        }
      } else {
        Logger.w('Registration failed: ${signupResponse.error}');
        ClarityService.to.trackAuthEvent(ClarityConfig.eventSignupFailed, properties: {
          'error': signupResponse.error,
          'has_email': email.isNotEmpty,
          'has_mobile': mobile.isNotEmpty
        });
        final errorMessage = signupResponse.error.isNotEmpty 
            ? signupResponse.error 
            : 'Registration failed. Please try again.';
        ToastService.error(errorMessage);
      }

    } catch (e, st) {
      Logger.e('Registration error', error: e, stackTrace: st);
      ClarityService.to.trackError(ClarityConfig.errorApi, e.toString(), properties: {
        'action': 'register',
        'has_email': email.isNotEmpty,
        'has_mobile': mobile.isNotEmpty
      });
      final errorMessage = ApiErrorHandler.handleError(e);
      ToastService.error(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> signUpWithGoogle() async {
    try {
      isLoading.value = true;
      
      await Future.delayed(const Duration(seconds: 2));
      
      Logger.i('Google Sign Up successful');
      
      Get.offAllNamed('/main');
      
    } catch (e) {
      Logger.e('Google Sign Up failed', error: e);
    } finally {
      isLoading.value = false;
    }
  }
  
  void navigateToLogin() {
    Get.back();
  }
  
  void navigateToTermsOfService() {
    Logger.i('Navigate to Terms of Service');
  }
  
  void navigateToPrivacyPolicy() {
    Logger.i('Navigate to Privacy Policy');
  }
  
  // Validation methods for form fields
  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }
  
  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }
  
  String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.trim().length != 10) {
      return 'Phone number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Phone number must contain only digits';
    }
    return null;
  }
  
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
