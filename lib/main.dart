import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/utils/preference_utils.dart';
import 'core/utils/logger.dart';
import 'core/services/json_translation_service.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await _initializeServices();
  
  runApp(const MyApp());
}

Future<void> _initializeServices() async {
  try {
    await PreferenceUtils.init();
    Get.put(JsonTranslationService(), permanent: true);
    Logger.i('App services initialized successfully');
  } catch (e) {
    Logger.e('Error initializing services', error: e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      locale: const Locale('en', ''),
      fallbackLocale: const Locale('en', ''),
      initialRoute: AppPages.login,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      enableLog: true,
      logWriterCallback: (text, {bool isError = false}) {
        if (isError) {
          Logger.e('GetX: $text');
        } else {
          Logger.d('GetX: $text');
        }
      },
    );
  }
}
