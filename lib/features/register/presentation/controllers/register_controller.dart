import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/api_error_handler.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/services/auth_service.dart';

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
    if (!isTermsAccepted.value) {
      ToastService.error('Please accept Terms & Conditions');
      return;
    }

    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String mobile = phoneController.text.trim();

    if (firstName.isEmpty) {
      ToastService.error('First name is required');
      return;
    }

    if (lastName.isEmpty) {
      ToastService.error('Last name is required');
      return;
    }

    if (email.isEmpty && mobile.isEmpty) {
      ToastService.error('Email or phone number is required');
      return;
    }

    if (email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        ToastService.error('Please enter a valid email address');
        return;
      }
    }

    if (mobile.isNotEmpty) {
      final phoneRegex = RegExp(r'^[+]?[0-9]{10,15}$');
      if (!phoneRegex.hasMatch(mobile)) {
        ToastService.error('Please enter a valid phone number');
        return;
      }
    }

    try {
      isLoading.value = true;
      
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

        if (signupResponse.verifyMobileNoOTP && signupResponse.verifyEmailOTP) {
          Get.toNamed('/mobile-verification', arguments: {
            'mobile': mobile,
            'countryCode': countryCode,
            'needsEmailVerification': true,
            'email': email,
            'tokenId': signupResponse.tokenId,
            'flow': 'register'
          });
        } else if (signupResponse.verifyMobileNoOTP && mobile.isNotEmpty) {
          Get.toNamed('/mobile-verification', arguments: {
            'mobile': mobile,
            'countryCode': countryCode,
            'tokenId': signupResponse.tokenId,
            'flow': 'register'
          });
        } else if (signupResponse.verifyEmailOTP && email.isNotEmpty) {
          Get.toNamed('/email-verification', arguments: {
            'email': email,
            'tokenId': signupResponse.tokenId,
            'flow': 'register'
          });
        }
      } else {
        Logger.w('Registration failed: ${signupResponse.error}');
        final errorMessage = signupResponse.error.isNotEmpty 
            ? signupResponse.error 
            : 'Registration failed. Please try again.';
        ToastService.error(errorMessage);
      }

    } catch (e, st) {
      Logger.e('Registration error', error: e, stackTrace: st);
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
}
