import 'package:get/get.dart';
import '../controllers/mobile_verification_controller.dart';

class MobileVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MobileVerificationController>(() => MobileVerificationController());
  }
}


