import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/recaptcha_service.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/services/toast_service.dart';

class LoginController extends GetxController {
  // Text controllers
  final TextEditingController emailController = TextEditingController();
  
  // Observable variables
  final RxBool isEmailInput = true.obs;
  final RxBool isLoading = false.obs;
  final Rx<CountryCode> selectedCountry = CountryCode.fromCountryCode('IN').obs;
  
  // Services
  final ApiClient _apiClient = ApiClient();
  final RecaptchaService _recaptchaService = RecaptchaService();
  final TokenStorageService _tokenStorage = TokenStorageService();
  
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
  
  void _performSendOtp() async {
    try {
      isLoading.value = true;
      
      // Generate reCAPTCHA token
      final reCaptchaToken = await _recaptchaService.generateLoginToken();
      
      // Prepare request data
      final requestData = {
        'reCaptchaToken': reCaptchaToken,
        'platform': 'android',
        if (isEmailInput.value) 'email': emailController.text.trim(),
        if (!isEmailInput.value) 'mobileNo': emailController.text.trim(),
      };
      
      // Make API call
      final response = await _apiClient.postJson<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: requestData,
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        final success = data['success'] ?? false;
        final loginTokenId = data['loginTokenId'];
        
        if (success && loginTokenId != null) {
          await _tokenStorage.saveLoginTokens('', loginTokenId);
          
          ToastService.success(AppStrings.otpSentSuccessfully);
          
          // Navigate to verification screen
          if (isEmailInput.value) {
            Get.toNamed('/email-verification', arguments: {
              'email': emailController.text.trim(),
              'loginTokenId': loginTokenId,
              'flow':'login'
            });
          } else {
            Get.toNamed('/mobile-verification', arguments: {
              'mobileNo': emailController.text.trim(),
              'countryCode': selectedCountry.value.dialCode??"",
              'loginTokenId': loginTokenId,
              'flow':'login'

            });
          }
        } else {
          _showErrorToast(data['error'] ?? AppStrings.errorSendingOtp);
        }
      } else {
        _showErrorToast(AppStrings.errorSendingOtp);
      }
      
    } catch (e) {
      Logger.e('Error sending OTP', error: e);
      _showErrorToast(AppStrings.errorSendingOtp);
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
      ToastService.success(AppStrings.googleSignInSuccess);
      
      // Navigate to home screen after successful login
      Get.offAllNamed('/main');
      
    } catch (e) {
      Logger.e('Error with Google Sign-In', error: e);
      _showErrorToast(AppStrings.googleSignInError);
    } finally {
      isLoading.value = false;
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
