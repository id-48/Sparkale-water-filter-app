import 'dart:io' show Platform;
import '../utils/logger.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'toast_service.dart';

class RecaptchaService {

  static const String _androidSiteKey = '6Lfo8WIqAAAAAOPE8wq_mPmoYAnkFNugIZVLJTQr';
  static const String _iosSiteKey = '6LeuHmMqAAAAAM4MSY2tTxok9WgsW3fZ5voBWS3B';

  Future<String> generateSignUpToken({String action = 'SIGNUP'}) async {
    try {
      final String siteKey = Platform.isAndroid ? _androidSiteKey : _iosSiteKey;

      final RecaptchaClient client = await Recaptcha.fetchClient(siteKey);

      final String token = await client.execute(RecaptchaAction.custom(action));
      if (token.isEmpty) {
        throw Exception('Empty reCAPTCHA token');
      }
      Logger.i('Recaptcha token generated');
      return token;
    } catch (e, st) {
      Logger.e('Recaptcha execute failed', error: e, stackTrace: st);
      ToastService.error('Unable to verify reCAPTCHA');
      rethrow;
    }
  }

  Future<String> generateSignUpVerificationToken({String action = 'SIGNUPVERIFICATION'}) async {
    try {
      final String siteKey = Platform.isAndroid ? _androidSiteKey : _iosSiteKey;

      final RecaptchaClient client = await Recaptcha.fetchClient(siteKey);

      final String token = await client.execute(RecaptchaAction.custom(action));
      if (token.isEmpty) {
        throw Exception('Empty reCAPTCHA token');
      }
      Logger.i('Recaptcha token generated');
      return token;
    } catch (e, st) {
      Logger.e('Recaptcha execute failed', error: e, stackTrace: st);
      ToastService.error('Unable to verify reCAPTCHA');
      rethrow;
    }
  }

  Future<String> generateLoginToken({String action = 'LOGIN'}) async {
    try {
      final String siteKey = Platform.isAndroid ? _androidSiteKey : _iosSiteKey;

      final RecaptchaClient client = await Recaptcha.fetchClient(siteKey);

      final String token = await client.execute(RecaptchaAction.custom(action));
      if (token.isEmpty) {
        throw Exception('Empty reCAPTCHA token');
      }
      Logger.i('Login reCAPTCHA token generated');
      return token;
    } catch (e, st) {
      Logger.e('Login reCAPTCHA execute failed', error: e, stackTrace: st);
      ToastService.error('Unable to verify reCAPTCHA');
      rethrow;
    }
  }

  Future<String> generateLoginVerificationToken({String action = 'LOGINVERIFICATION'}) async {
    try {
      final String siteKey = Platform.isAndroid ? _androidSiteKey : _iosSiteKey;

      final RecaptchaClient client = await Recaptcha.fetchClient(siteKey);

      final String token = await client.execute(RecaptchaAction.custom(action));
      if (token.isEmpty) {
        throw Exception('Empty reCAPTCHA token');
      }
      Logger.i('Login verification reCAPTCHA token generated');
      return token;
    } catch (e, st) {
      Logger.e('Login verification reCAPTCHA execute failed', error: e, stackTrace: st);
      ToastService.error('Unable to verify reCAPTCHA');
      rethrow;
    }
  }

  Future<String> generateResendLoginOTPToken({String action = 'RESENDLOGINOTP'}) async {
    try {
      final String siteKey = Platform.isAndroid ? _androidSiteKey : _iosSiteKey;

      final RecaptchaClient client = await Recaptcha.fetchClient(siteKey);

      final String token = await client.execute(RecaptchaAction.custom(action));
      if (token.isEmpty) {
        throw Exception('Empty reCAPTCHA token');
      }
      Logger.i('Login verification reCAPTCHA token generated');
      return token;
    } catch (e, st) {
      Logger.e('Login verification reCAPTCHA execute failed', error: e, stackTrace: st);
      ToastService.error('Unable to verify reCAPTCHA');
      rethrow;
    }
  }

  Future<String> generateResendSignUpOTPToken({String action = 'RESENDSIGNUPOTP'}) async {
    try {
      final String siteKey = Platform.isAndroid ? _androidSiteKey : _iosSiteKey;

      final RecaptchaClient client = await Recaptcha.fetchClient(siteKey);

      final String token = await client.execute(RecaptchaAction.custom(action));
      if (token.isEmpty) {
        throw Exception('Empty reCAPTCHA token');
      }
      Logger.i('Resend signup OTP reCAPTCHA token generated');
      return token;
    } catch (e, st) {
      Logger.e('Resend signup OTP reCAPTCHA execute failed', error: e, stackTrace: st);
      ToastService.error('Unable to verify reCAPTCHA');
      rethrow;
    }
  }
}


