import 'package:get/get.dart';
import '../../../../core/constants/clarity_config.dart';
import '../../../../core/utils/translation_helper.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/services/clarity_service.dart';

class HomeController extends GetxController {
  
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    ClarityService.to.trackScreenView(ClarityConfig.screenHome);
    _initializeHome();
  }
  
  Future<void> _initializeHome() async {
    try {
      isLoading.value = true;
      Logger.user('Home screen initialized');
      await _loadInitialData();
    } catch (e) {
      Logger.e('Error initializing home', error: e);
      ToastService.error(Tr.unknownError);
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> _loadInitialData() async {
  }
  
  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      ClarityService.to.trackUserAction(ClarityConfig.actionRefreshData);
      await _loadInitialData();
    } catch (e) {
      Logger.e('Error refreshing data', error: e);
      ClarityService.to.trackError(ClarityConfig.errorRefreshData, e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
