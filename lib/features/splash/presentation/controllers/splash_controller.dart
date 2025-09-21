import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/preference_utils.dart';
import '../../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    try {
      // Initialize preferences
      await PreferenceUtils.init();
      
      // Wait for splash duration
      await Future.delayed(const Duration(milliseconds: AppConstants.splashDuration));
      
      // Navigate to appropriate screen
      _navigateToNextScreen();
    } catch (e) {
      // Handle initialization error
      _navigateToNextScreen();
    }
  }
  
  void _navigateToNextScreen() {
    // Check if user is logged in or first time
    final isFirstTime = PreferenceUtils.isFirstTime();
    final userToken = PreferenceUtils.getUserToken();
    
    if (isFirstTime || userToken == null) {
      // Navigate to onboarding or login
      Get.offAllNamed(AppPages.home);
    } else {
      // Navigate to home
      Get.offAllNamed(AppPages.home);
    }
  }
}
