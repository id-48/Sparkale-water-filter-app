import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize ProfileController immediately to pre-load profile data
    Get.put<ProfileController>(ProfileController(), permanent: true);
  }
}
