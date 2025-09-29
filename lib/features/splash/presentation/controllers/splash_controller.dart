import 'package:get/get.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/clarity_config.dart';
import '../../../../core/utils/preference_utils.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../../../core/services/clarity_service.dart';

class SplashController extends GetxController {
  final TokenStorageService _tokenStorage = TokenStorageService();

  @override
  void onInit() {
    super.onInit();
    ClarityService.to.trackScreenView(ClarityConfig.screenSplash);
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
      final jwtToken = await _tokenStorage.getJWTToken();
      
      if (jwtToken != null && jwtToken.isNotEmpty) {
        Logger.i('JWT token found, navigating to main screen');
        ClarityService.to.trackAuthEvent(ClarityConfig.eventLoginSuccess, properties: {'type': 'auto_login'});
        ClarityService.to.trackNavigation(ClarityConfig.screenSplash, ClarityConfig.screenHome);
        Get.offAllNamed('/main');
      } else {
        Logger.i('No JWT token found, navigating to login screen');
        ClarityService.to.trackAuthEvent(ClarityConfig.eventLoginFailed, properties: {'reason': 'no_token', 'type': 'auto_login'});
        ClarityService.to.trackNavigation(ClarityConfig.screenSplash, ClarityConfig.screenLogin);
        Get.offAllNamed('/login');
      }
    } catch (e) {
      Logger.e('Error checking authentication', error: e);
      ClarityService.to.trackError(ClarityConfig.errorAuthCheck, e.toString());
      ClarityService.to.trackNavigation(ClarityConfig.screenSplash, ClarityConfig.screenLogin);
      Get.offAllNamed('/login');
    }
  }
}
