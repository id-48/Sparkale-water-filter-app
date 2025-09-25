import 'package:get/get.dart';
import '../../../../core/utils/translation_helper.dart';
import '../../../../core/utils/logger.dart';

class HomeController extends GetxController {
  
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _initializeHome();
  }
  
  Future<void> _initializeHome() async {
    try {
      isLoading.value = true;
      Logger.user('Home screen initialized');
      await _loadInitialData();
    } catch (e) {
      Logger.e('Error initializing home', error: e);
      Get.snackbar(
        Tr.error,
        Tr.unknownError,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> _loadInitialData() async {
    // Load initial data here
  }
  
  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      await _loadInitialData();
    } catch (e) {
      Logger.e('Error refreshing data', error: e);
    } finally {
      isLoading.value = false;
    }
  }
}
