import 'dart:io' show Platform;
import 'package:get/get.dart';
import '../utils/logger.dart';
import 'package:flutter/services.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_client.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';

class RecaptchaService {
  RecaptchaService._internal();
  static final RecaptchaService _instance = RecaptchaService._internal();
  factory RecaptchaService() => _instance;

  // bool _initialized = false;

  static const String _androidSiteKey = '6Lfo8WIqAAAAAOPE8wq_mPmoYAnkFNugIZVLJTQr';
  static const String _iosSiteKey = '6LeuHmMqAAAAAM4MSY2tTxok9WgsW3fZ5voBWS3B';

  // Future<void> _ensureInitialized() async {
  //   if (_initialized) return;
  //   final String siteKey = Platform.isAndroid ? _androidSiteKey : _iosSiteKey;
  //   try {
  //     final bool ok = await RecaptchaEnterprise.initClient(siteKey, timeout: 15000);
  //     _initialized = ok;
  //     Logger.i('Recaptcha initialized: $ok');
  //   } catch (e, st) {
  //     Logger.e('Recaptcha init failed', error: e, stackTrace: st);
  //     rethrow;
  //   }
  // }

  Future<String> generateSignUpToken({String action = 'SIGNUP'}) async {
    // await _ensureInitialized();
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
      Get.snackbar('Security Check', 'Unable to verify reCAPTCHA');
      rethrow;
    }
  }

  Future<String> generateSignUpVerificationToken({String action = 'SIGNUPVERIFICATION'}) async {
    // await _ensureInitialized();
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
      Get.snackbar('Security Check', 'Unable to verify reCAPTCHA');
      rethrow;
    }
  }
}


