import 'package:get/get.dart';
import '../features/splash/presentation/views/splash_view.dart';
import '../features/splash/presentation/bindings/splash_binding.dart';
import '../features/main/presentation/views/main_view.dart';
import '../features/main/presentation/bindings/main_binding.dart';
import '../features/login/presentation/views/login_view.dart';
import '../features/login/presentation/bindings/login_binding.dart';
import '../features/register/presentation/views/register_view.dart';
import '../features/register/presentation/bindings/register_binding.dart';
import '../features/email_verification/presentation/views/email_verification_view.dart';
import '../features/email_verification/presentation/bindings/email_verification_binding.dart';
import '../features/mobile_verification/presentation/views/mobile_verification_view.dart';
import '../features/mobile_verification/presentation/bindings/mobile_verification_binding.dart';

class AppPages {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String emailVerification = '/email-verification';
  static const String mobileVerification = '/mobile-verification';
  static const String main = '/main';
  
  static final List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: emailVerification,
      page: () =>  EmailVerificationView(),
      binding: EmailVerificationBinding(),
    ),
    GetPage(
      name: mobileVerification,
      page: () =>  MobileVerificationView(),
      binding: MobileVerificationBinding(),
    ),
    GetPage(
      name: main,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
  ];
}
