import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../utils/preference_utils.dart';
import '../constants/app_constants.dart';

class JsonTranslationService extends GetxService {
  static JsonTranslationService get to => Get.find();
  
  final RxString _currentLanguage = 'en'.obs;
  final RxMap<String, String> _translations = <String, String>{}.obs;
  
  String get currentLanguage => _currentLanguage.value;
  Map<String, String> get translations => _translations;
  
  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }
  
  void _loadSavedLanguage() async {
    final savedLanguage = PreferenceUtils.getString(AppConstants.selectedLanguageKey, defaultValue: 'en');
    _currentLanguage.value = savedLanguage ?? 'en';
    await _loadTranslations(_currentLanguage.value);
  }
  
  Future<void> _loadTranslations(String languageCode) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/translations/$languageCode.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      _translations.clear();
      jsonMap.forEach((key, value) {
        _translations[key] = value.toString();
      });
      
      Get.updateLocale(Locale(languageCode));
    } catch (e) {
      if (languageCode != 'en') {
        await _loadTranslations('en');
      }
    }
  }
  
  Future<void> changeLanguage(String languageCode) async {
    try {
      _currentLanguage.value = languageCode;
      await _loadTranslations(languageCode);
      await PreferenceUtils.setString(AppConstants.selectedLanguageKey, languageCode);
      Get.snackbar(
        getTranslation('success'),
        getTranslation('languageChanged'),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        getTranslation('error'),
        getTranslation('unknownError'),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  String getTranslation(String key) {
    return _translations[key] ?? key;
  }
  
  List<Map<String, String>> get availableLanguages => [
    {
      'code': 'en',
      'name': 'english',
      'nativeName': 'English',
    },
    {
      'code': 'gu',
      'name': 'gujarati',
      'nativeName': 'ગુજરાતી',
    },
  ];
  
  bool get isRTL => _currentLanguage.value == 'ar' || _currentLanguage.value == 'he';
  
  String getLanguageName(String code) {
    final language = availableLanguages.firstWhereOrNull(
      (lang) => lang['code'] == code,
    );
    return language?['nativeName'] ?? 'English';
  }
}
