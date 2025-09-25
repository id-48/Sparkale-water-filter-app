import '../services/json_translation_service.dart';
import '../constants/translation_keys.dart';

class T {
  static String get(String key) {
    try {
      return JsonTranslationService.to.getTranslation(key);
    } catch (e) {
      return key;
    }
  }
}

class Tr {
  static String get appName => T.get(TranslationKeys.appName);
  static String get error => T.get(TranslationKeys.error);
  static String get success => T.get(TranslationKeys.success);
  static String get splashSubtitle => T.get(TranslationKeys.splashSubtitle);
  static String get languageChanged => T.get(TranslationKeys.languageChanged);
  static String get unknownError => T.get(TranslationKeys.unknownError);
  static String get noDataFound => T.get(TranslationKeys.noDataFound);

  // Home / Bottom Nav
  static String get homeTitle => T.get('homeTitle');
  static String get support => T.get('support');
  static String get profile => T.get('profile');

  // Profile
  static String get accountSetting => T.get('accountSetting');
  static String get personalInformation => T.get('personalInformation');
  static String get billingInformation => T.get('billingInformation');
  static String get signOut => T.get('signOut');

  // Login
  static String get loginTitle => T.get('loginTitle');
  static String get loginSubtitle => T.get('loginSubtitle');
  static String get back => T.get('back');
  static String get backToLogin => T.get('backToLogin');
  static String get verifyEmail => T.get('verifyEmail');
  static String get verifyMono => T.get('verifyMono');
  static String get enterCodeEmail => T.get('enterCodeEmail');
  static String get enterCodeMo => T.get('enterCodeMo');
  static String get email => T.get('email');
  static String get mono => T.get('mono');
  static String get useMobileNumber => T.get('useMobileNumber');
  static String get useEmail => T.get('useEmail');
  static String get enterEmail => T.get('enterEmail');
  static String get enterMobileNumber => T.get('enterMobileNumber');
  static String get sendOtp => T.get('sendOtp');
  static String get verifyOtp => T.get('verifyOtp');
  static String get didntReciveEmail => T.get('didntReciveEmail');
  static String get clickToSend => T.get('clickToSend');
  static String get codeResendAfter => T.get('codeResendAfter');
  static String get enter10DigitMobileNumber => T.get('enter10DigitMobileNumber');
  static String get or => T.get('or');
  static String get signInWithGoogle => T.get('signInWithGoogle');
  static String get dontHaveAccount => T.get('dontHaveAccount');
  static String get signUp => T.get('signUp');

  // Register
  static String get registerTitle => T.get('registerTitle');
  static String get registerSubtitle => T.get('registerSubtitle');
  static String get firstName => T.get('firstName');
  static String get lastName => T.get('lastName');
  static String get phoneNumber => T.get('phoneNumber');
  static String get enterFirstName => T.get('enterFirstName');
  static String get enterLastName => T.get('enterLastName');
  static String get enterPhoneNumber => T.get('enterPhoneNumber');
  static String get byProviding => T.get('byProviding');
  static String get and => T.get('and');
  static String get inuseOfApp => T.get('inuseOfApp');
  static String get signWithGoogle => T.get('signWithGoogle');
  static String get termsOfService => T.get('termsOfService');
  static String get privacyPolicy => T.get('privacyPolicy');
  static String get alreadyHaveAccount => T.get('alreadyHaveAccount');
  static String get signIn => T.get('signIn');
  static String get language => T.get('language');
  static String get selectLanguage => T.get('selectLanguage');
}
