import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/logger.dart';

class FCMService {
  Future<String> getToken() async {
    try {
      String token;
      if (Platform.isAndroid) {
        token = await FirebaseMessaging.instance.getToken() ?? "";
      } else {
        token = await FirebaseMessaging.instance.getAPNSToken() ?? "";
      }
      return token;
    } catch (e, st) {
      Logger.e('FCM token generation failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
