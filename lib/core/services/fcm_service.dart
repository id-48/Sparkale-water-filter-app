import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/logger.dart';

class FCMService {
  FCMService._internal();

  static final FCMService _instance = FCMService._internal();

  factory FCMService() => _instance;

  // Future<String> getToken() async {
  //   try {
  //
  //     if (token == null) {
  //       throw Exception('Failed to get FCM token');
  //     }
  //     return token;
  //   } catch (e, st) {
  //     Logger.e('FCM token generation failed', error: e, stackTrace: st);
  //     rethrow;
  //   }
  // }
}
