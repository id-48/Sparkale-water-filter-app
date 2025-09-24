import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../../../../core/utils/logger.dart';

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
    Get.offNamed('/email-verification', arguments: {
      'email': emailController.text.trim(),
    });
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
    // TODO: Implement navigation to Terms of Service
    Logger.i('Navigate to Terms of Service');
  }
  
  // Navigate to Privacy Policy
  void navigateToPrivacyPolicy() {
    // TODO: Implement navigation to Privacy Policy
    Logger.i('Navigate to Privacy Policy');
  }
}
