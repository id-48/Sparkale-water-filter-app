import '../services/json_translation_service.dart';
import '../constants/translation_keys.dart';

class T {
  static String get(String key) {
    try {
      return JsonTranslationService.to.getTranslation(key);
    } catch (e) {
      return key; // Return key if translation not found
    }
  }
}

// Helper class for translation keys
class Tr {
  static String get appName => T.get(TranslationKeys.appName);
  static String get appVersion => T.get(TranslationKeys.appVersion);
  static String get loading => T.get(TranslationKeys.loading);
  static String get error => T.get(TranslationKeys.error);
  static String get success => T.get(TranslationKeys.success);
  static String get retry => T.get(TranslationKeys.retry);
  static String get cancel => T.get(TranslationKeys.cancel);
  static String get ok => T.get(TranslationKeys.ok);
  static String get yes => T.get(TranslationKeys.yes);
  static String get no => T.get(TranslationKeys.no);
  static String get save => T.get(TranslationKeys.save);
  static String get delete => T.get(TranslationKeys.delete);
  static String get edit => T.get(TranslationKeys.edit);
  static String get add => T.get(TranslationKeys.add);
  static String get search => T.get(TranslationKeys.search);
  static String get filter => T.get(TranslationKeys.filter);
  static String get sort => T.get(TranslationKeys.sort);
  static String get refresh => T.get(TranslationKeys.refresh);
  static String get back => T.get(TranslationKeys.back);
  static String get next => T.get(TranslationKeys.next);
  static String get previous => T.get(TranslationKeys.previous);
  static String get done => T.get(TranslationKeys.done);
  static String get close => T.get(TranslationKeys.close);
  static String get splashTitle => T.get(TranslationKeys.splashTitle);
  static String get splashSubtitle => T.get(TranslationKeys.splashSubtitle);
  static String get homeTitle => T.get(TranslationKeys.homeTitle);
  static String get welcomeMessage => T.get(TranslationKeys.welcomeMessage);
  static String get counterDemo => T.get(TranslationKeys.counterDemo);
  static String get increase => T.get(TranslationKeys.increase);
  static String get decrease => T.get(TranslationKeys.decrease);
  static String get reset => T.get(TranslationKeys.reset);
  static String get appFeatures => T.get(TranslationKeys.appFeatures);
  static String get mvcArchitecture => T.get(TranslationKeys.mvcArchitecture);
  static String get mvcArchitectureDesc => T.get(TranslationKeys.mvcArchitectureDesc);
  static String get getxStateManagement => T.get(TranslationKeys.getxStateManagement);
  static String get getxStateManagementDesc => T.get(TranslationKeys.getxStateManagementDesc);
  static String get localStorage => T.get(TranslationKeys.localStorage);
  static String get localStorageDesc => T.get(TranslationKeys.localStorageDesc);
  static String get customTheme => T.get(TranslationKeys.customTheme);
  static String get customThemeDesc => T.get(TranslationKeys.customThemeDesc);
  static String get multiLanguage => T.get(TranslationKeys.multiLanguage);
  static String get multiLanguageDesc => T.get(TranslationKeys.multiLanguageDesc);
  static String get language => T.get(TranslationKeys.language);
  static String get selectLanguage => T.get(TranslationKeys.selectLanguage);
  static String get english => T.get(TranslationKeys.english);
  static String get gujarati => T.get(TranslationKeys.gujarati);
  static String get languageChanged => T.get(TranslationKeys.languageChanged);
  static String get unknownError => T.get(TranslationKeys.unknownError);
  static String get noDataFound => T.get(TranslationKeys.noDataFound);
}
