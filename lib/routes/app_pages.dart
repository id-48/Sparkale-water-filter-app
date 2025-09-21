import 'package:get/get.dart';
import '../features/splash/presentation/views/splash_view.dart';
import '../features/splash/presentation/bindings/splash_binding.dart';
import '../features/home/presentation/views/home_view.dart';
import '../features/home/presentation/bindings/home_binding.dart';

class AppPages {
  static const String splash = '/splash';
  static const String home = '/home';
  
  static final List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
