import '../widgets/custom_toast.dart';

class ToastService {
  static void success(String message) {
    CustomToast.success(message);
  }

  static void error(String message) {
    CustomToast.error(message);
  }
}
