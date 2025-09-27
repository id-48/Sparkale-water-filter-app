import 'package:get/get.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/api_error_handler.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/models/auth/profile/customer.dart';
import '../widgets/language_selection_dialog.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isProfileLoading = false.obs;
  final AuthService _authService = AuthService();
  
  final Rx<Customer?> customer = Rx<Customer?>(null);

  @override
  void onInit() {
    super.onInit();
    Logger.i('ProfileController initialized');
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      isProfileLoading.value = true;
      Logger.d('Fetching profile data');
      
      final profileResponse = await _authService.getCustomerProfile();
      
      if (profileResponse.success) {
        customer.value = profileResponse.customer;
        Logger.d('Profile data loaded successfully: ${profileResponse.customer.fullName}');
      } else {
        Logger.w('Failed to load profile data: ${profileResponse.error}');
      }
      
    } catch (e, st) {
      Logger.e('Error fetching profile data', error: e, stackTrace: st);
    } finally {
      isProfileLoading.value = false;
    }
  }
  
  void refreshProfile() {
    _fetchProfileData();
  }

  void navigateToPersonalInfo() {
    Logger.d('Navigate to Personal Info');
  }

  void navigateToBillingInfo() {
    Logger.d('Navigate to Billing Info');
  }

  Future<void> signOut() async {
    if (isLoading.value) return;
    
    try {
      isLoading.value = true;
      Logger.d('Sign out requested');
      
      final logoutResponse = await _authService.logout();
      
      if (logoutResponse.success) {
        Logger.d('Logout successful');
        ToastService.success('Log out successfully');
        
        Get.offAllNamed('/login');
      } else {
        Logger.w('Logout failed: ${logoutResponse.error}');
        final errorMessage = logoutResponse.error.isNotEmpty 
            ? logoutResponse.error 
            : 'Logout failed. Please try again.';
        ToastService.error(errorMessage);
      }
      
    } catch (e, st) {
      Logger.e('Error during logout', error: e, stackTrace: st);
      final errorMessage = ApiErrorHandler.handleError(e);
      ToastService.error(errorMessage);
      
      try {
        await _authService.clearLocalTokens();
        Logger.d('Local tokens cleared after logout error');
        Get.offAllNamed('/login');
      } catch (clearError) {
        Logger.e('Failed to clear local tokens', error: clearError);
        Get.offAllNamed('/login');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void showLanguageDialog() {
    Logger.d('Show language selection dialog');
    
    if (Get.context != null) {
      Get.dialog(
        const LanguageSelectionDialog(),
        barrierDismissible: true,
      );
    } else {
      Logger.e('No valid context available for showing dialog');
    }
  }
}
