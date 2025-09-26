import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/recaptcha_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/auth/signup_models.dart';
import '../../../../core/services/toast_service.dart';

class RegisterController extends GetxController {
  // Form Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  
  // Form Key
  GlobalKey<FormState> get formKey => _formKey;
  late final GlobalKey<FormState> _formKey;
  
  // Observable Variables
  final RxBool isTermsAccepted = false.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCountryCode = '+1'.obs;
  final RxString selectedCountryFlag = '🇺🇸'.obs;
  
  
  @override
  void onInit() {
    super.onInit();
    _formKey = GlobalKey<FormState>(debugLabel: 'RegisterForm_${DateTime.now().millisecondsSinceEpoch}');
    Logger.i('RegisterController initialized');
  }
  
  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
  
  // Country Code Selection
  void onCountryChanged(CountryCode countryCode) {
    selectedCountryCode.value = countryCode.dialCode ?? '+1';
    selectedCountryFlag.value = countryCode.flagUri ?? '🇺🇸';
    Logger.d('Country changed to: ${countryCode.name} ${countryCode.dialCode}');
  }
  
  // Terms and Conditions Toggle
  void toggleTermsAcceptance() {
    isTermsAccepted.value = !isTermsAccepted.value;
    Logger.d('Terms acceptance toggled: ${isTermsAccepted.value}');
  }

  void navigateToSignUp() {
    Logger.d('Navigate to Sign Up');
    Get.toNamed('/login');
  }

  
  // Register User
  Future<void> registerUser() async {
    if (isLoading.value) return;
    if (!isTermsAccepted.value) {
      ToastService.error('Please accept Terms & Conditions');
      return;
    }

    // Validate form fields
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String mobile = phoneController.text.trim();

    // Check required field validation
    if (firstName.isEmpty) {
      ToastService.error('First name is required');
      return;
    }

    if (lastName.isEmpty) {
      ToastService.error('Last name is required');
      return;
    }

    // At least one of email or phone must be provided
    if (email.isEmpty && mobile.isEmpty) {
      ToastService.error('Email or phone number is required');
      return;
    }

    if (email.isNotEmpty) {
      // Validate email format if provided
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        ToastService.error('Please enter a valid email address');
        return;
      }
    }

    if (mobile.isNotEmpty) {
      // Validate phone format if provided
      final phoneRegex = RegExp(r'^[+]?[0-9]{10,15}$');
      if (!phoneRegex.hasMatch(mobile)) {
        ToastService.error('Please enter a valid phone number');
        return;
      }
    }

    try {
      isLoading.value = true;

      final String countryCode = selectedCountryCode.value.replaceAll('+', '');

      final String recaptchaToken = await RecaptchaService().generateSignUpToken();

      final SignupRequest request = SignupRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobileNo: mobile,
        imageBase64: null,
        countryCode: countryCode,
        reCaptchaToken: recaptchaToken,
        platform: GetPlatform.isAndroid ? 'android' : 'ios',
      );

      Logger.api('Register request', endpoint: ApiEndpoints.signup, data: request.toJson());

      final response = await ApiClient().postJson<Map<String, dynamic>>(
        ApiEndpoints.signup,
        data: request.toJson(),
        options: Options(responseType: ResponseType.json),
      );

      final data = response.data ?? <String, dynamic>{};
      Logger.api('Register response', endpoint: ApiEndpoints.signup, data: data);

      final signupResponse = SignupResponse.fromJson(data);
      if (!signupResponse.success) {
        String errorMessage = signupResponse.error.isNotEmpty ? signupResponse.error : 'Something went wrong';
        // Use reasonCode if available from response
        if (signupResponse.reasonCode.isNotEmpty) {
          errorMessage = signupResponse.reasonCode;
        }
        ToastService.error(errorMessage);
        return;
      }

      // Show success toast
      ToastService.success('Code Send Successfully.');

      final bool verifyMobileNoOTP = signupResponse.verifyMobileNoOTP;
      final bool verifyEmailOTP = signupResponse.verifyEmailOTP;

      final String tokenId = signupResponse.tokenId ??"";

      if (verifyMobileNoOTP && verifyEmailOTP) {
        Get.toNamed('/mobile-verification', arguments: {
          'mobile': mobile,
          'tokenId': tokenId,
          'needsEmailVerification': true,
          'email': email,
          'flow':'register'
        });
        return;
      }

      if (verifyMobileNoOTP) {
        Get.toNamed('/mobile-verification', arguments: {
          'mobile': mobile,
          'tokenId': tokenId,
          'flow': 'register'
        });
        return;
      }

      if (verifyEmailOTP) {
        Get.toNamed('/email-verification', arguments: {
          'email': email,
          'tokenId': tokenId,
          'flow':'register'
        });
        return;
      }

    } on DioException catch (e, st) {
      Logger.e('Register API error', error: e, stackTrace: st);
      String errorMessage = 'Network error';
      
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        if (data['reasonCode'] != null && data['reasonCode'].toString().isNotEmpty) {
          errorMessage = data['reasonCode'].toString();
        } else if (data['error'] != null && data['error'].toString().isNotEmpty) {
          errorMessage = data['error'].toString();
        }
      }
      ToastService.error(errorMessage);
    } catch (e, st) {
      Logger.e('Register unexpected error', error: e, stackTrace: st);
      ToastService.error('Unexpected error');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Google Sign Up
  Future<void> signUpWithGoogle() async {
    try {
      isLoading.value = true;
      
      // Simulate Google Sign Up
      await Future.delayed(const Duration(seconds: 2));
      
      Logger.i('Google Sign Up successful');
      
      // Navigate to home
      Get.offAllNamed('/main');
      
    } catch (e) {
      Logger.e('Google Sign Up failed', error: e);
    } finally {
      isLoading.value = false;
    }
  }
  
  // Navigate to Login
  void navigateToLogin() {
    Get.back();
  }
  
  // Navigate to Terms of Service
  void navigateToTermsOfService() {
    Logger.i('Navigate to Terms of Service');
    // Terms of Service page will be implemented
  }
  
  // Navigate to Privacy Policy
  void navigateToPrivacyPolicy() {
    Logger.i('Navigate to Privacy Policy');
    // Privacy Policy page will be implemented
  }
}
