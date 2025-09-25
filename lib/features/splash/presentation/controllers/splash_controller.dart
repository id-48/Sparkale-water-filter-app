import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/preference_utils.dart';
import '../../../../core/utils/logger.dart';
import '../../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    try {
      await PreferenceUtils.init();
      await Future.delayed(const Duration(milliseconds: AppConstants.splashDuration));
      _navigateToNextScreen();
    } catch (e) {
      _navigateToNextScreen();
    }
  }
  
  void _navigateToNextScreen() {
    try {
      final isFirstTime = PreferenceUtils.isFirstTime();
      final userToken = PreferenceUtils.getUserToken();

      Future.delayed(const Duration(milliseconds: 100), () {
        Get.offAllNamed('/login');
      });
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.offAllNamed('/login');
      });
    }
  }
}
