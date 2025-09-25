import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/recaptcha_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/models/auth/signup_models.dart';

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
      Get.snackbar('Terms', 'Please accept Terms & Conditions');
      return;
    }

    try {
      isLoading.value = true;

      final String firstName = firstNameController.text.trim();
      final String lastName = lastNameController.text.trim();
      final String email = emailController.text.trim();
      final String mobile = phoneController.text.trim();
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
        final String error = signupResponse.error.isNotEmpty ? signupResponse.error : 'Something went wrong';
        Get.snackbar('Register Failed', error);
        return;
      }

      final bool verifyMobileNoOTP = signupResponse.verifyMobileNoOTP;
      final bool verifyEmailOTP = signupResponse.verifyEmailOTP;

      // Navigate per rules
      final String? tokenId = signupResponse.tokenId;

      if (verifyMobileNoOTP && verifyEmailOTP) {
        await Get.toNamed('/mobile-verification', arguments: {
          'mobile': mobile,
          'tokenId': tokenId,
        });
        await Get.toNamed('/email-verification', arguments: {
          'email': email,
          'tokenId': tokenId,
        });
        return;
      }

      if (verifyMobileNoOTP) {
        Get.toNamed('/mobile-verification', arguments: {
          'mobile': mobile,
          'tokenId': tokenId,
        });
        return;
      }

      if (verifyEmailOTP) {
        Get.toNamed('/email-verification', arguments: {
          'email': email,
          'tokenId': tokenId,
        });
        return;
      }

      // If no OTP required, proceed to main/home
      Get.offAllNamed('/main');
    } on DioException catch (e, st) {
      Logger.e('Register API error', error: e, stackTrace: st);
      final message = e.response?.data is Map<String, dynamic>
          ? ((e.response?.data as Map<String, dynamic>)['error'] ?? 'Network error').toString()
          : 'Network error';
      Get.snackbar('Register Failed', message);
    } catch (e, st) {
      Logger.e('Register unexpected error', error: e, stackTrace: st);
      Get.snackbar('Register Failed', 'Unexpected error');
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
