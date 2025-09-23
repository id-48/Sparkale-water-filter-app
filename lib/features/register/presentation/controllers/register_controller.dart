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
  final formKey = GlobalKey<FormState>();
  
  // Observable Variables
  final RxBool isTermsAccepted = false.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCountryCode = '+1'.obs;
  final RxString selectedCountryFlag = '🇺🇸'.obs;
  
  // Validation
  final RxString firstNameError = ''.obs;
  final RxString lastNameError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString emailError = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
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

  // Form Validation
  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      firstNameError.value = 'Please enter your first name';
      return firstNameError.value;
    }
    if (value.trim().length < 2) {
      firstNameError.value = 'First name must be at least 2 characters';
      return firstNameError.value;
    }
    firstNameError.value = '';
    return null;
  }
  
  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      lastNameError.value = 'Please enter your last name';
      return lastNameError.value;
    }
    if (value.trim().length < 2) {
      lastNameError.value = 'Last name must be at least 2 characters';
      return lastNameError.value;
    }
    lastNameError.value = '';
    return null;
  }
  
  String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      phoneError.value = 'Please enter your phone number';
      return phoneError.value;
    }
    if (value.trim().length < 10) {
      phoneError.value = 'Please enter a valid phone number';
      return phoneError.value;
    }
    phoneError.value = '';
    return null;
  }
  
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      emailError.value = 'Please enter your email address';
      return emailError.value;
    }
    if (!GetUtils.isEmail(value.trim())) {
      emailError.value = 'Please enter a valid email address';
      return emailError.value;
    }
    emailError.value = '';
    return null;
  }
  
  // Register User
  Future<void> registerUser() async {
    try {
      if (!formKey.currentState!.validate()) {
        Logger.w('Form validation failed');
        return;
      }
      
      if (!isTermsAccepted.value) {
        Get.snackbar(
          'Terms Required',
          'Please accept the Terms of Service and Privacy Policy',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      Logger.i('User registration successful');
      
      // Navigate to email verification screen
      Get.toNamed('/email-verification', arguments: {
        'email': emailController.text.trim(),
      });
      
    } catch (e) {
      Logger.e('Registration failed', error: e);
      Get.snackbar(
        'Error',
        'Registration failed. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      
      Get.snackbar(
        'Success',
        'Google Sign Up successful!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to home
      Get.offAllNamed('/home');
      
    } catch (e) {
      Logger.e('Google Sign Up failed', error: e);
      Get.snackbar(
        'Error',
        'Google Sign Up failed. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    Get.snackbar(
      'Info',
      'Terms of Service page will be implemented',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  // Navigate to Privacy Policy
  void navigateToPrivacyPolicy() {
    // TODO: Implement navigation to Privacy Policy
    Logger.i('Navigate to Privacy Policy');
    Get.snackbar(
      'Info',
      'Privacy Policy page will be implemented',
      snackPosition: SnackPosition.TOP,
    );
  }
}
