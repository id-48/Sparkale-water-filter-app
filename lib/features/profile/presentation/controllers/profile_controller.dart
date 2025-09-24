import 'package:get/get.dart';
import '../../../../core/utils/logger.dart';
import '../widgets/language_selection_dialog.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Logger.i('ProfileController initialized');
  }

  void navigateToPersonalInfo() {
    Logger.d('Navigate to Personal Info');
  }

  void navigateToBillingInfo() {
    Logger.d('Navigate to Billing Info');
  }

  void signOut() {
    Logger.d('Sign out requested');
    // Navigate back to login
    Get.offAllNamed('/login');
  }

  void showLanguageDialog() {
    Logger.d('Show language selection dialog');
    
    // Check if we have a valid context
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
