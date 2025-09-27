import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/preference_utils.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final TokenStorageService _tokenStorage = TokenStorageService();

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
    Future.delayed(const Duration(milliseconds: 100), () {
      _checkAuthenticationAndNavigate();
    });
  }

  void _checkAuthenticationAndNavigate() async {
    try {
      // Check if JWT token exists
      final jwtToken = await _tokenStorage.getJWTToken();
      
      if (jwtToken != null && jwtToken.isNotEmpty) {
        // User is authenticated, navigate to main screen
        Logger.i('JWT token found, navigating to main screen');
        Get.offAllNamed('/main');
      } else {
        // User is not authenticated, navigate to login screen
        Logger.i('No JWT token found, navigating to login screen');
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Logger.e('Error checking authentication', error: e);
      // On error, navigate to login screen
      Get.offAllNamed('/login');
    }
  }
}
