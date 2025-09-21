import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class Logger {
  static const String _tag = 'SparkaleApp';
  static void d(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _tag,
        level: 500,
      );
    }
  }
  static void i(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _tag,
        level: 800,
      );
    }
  }
  static void w(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _tag,
        level: 900,
      );
    }
  }
  
  static void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _tag,
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
  
  static void api(String message, {String? endpoint, Map<String, dynamic>? data}) {
    if (kDebugMode) {
      developer.log(
        'API: $message${endpoint != null ? ' - $endpoint' : ''}${data != null ? ' - Data: $data' : ''}',
        name: '${_tag}_API',
        level: 800,
      );
    }
  }
  static void network(String message, {String? url, int? statusCode}) {
    if (kDebugMode) {
      developer.log(
        'NETWORK: $message${url != null ? ' - $url' : ''}${statusCode != null ? ' - Status: $statusCode' : ''}',
        name: '${_tag}_NETWORK',
        level: 800,
      );
    }
  }
  
  static void db(String message, {String? table, String? operation}) {
    if (kDebugMode) {
      developer.log(
        'DB: $message${table != null ? ' - Table: $table' : ''}${operation != null ? ' - Operation: $operation' : ''}',
        name: '${_tag}_DB',
        level: 800,
      );
    }
  }
  
  static void user(String message, {String? screen, String? action}) {
    if (kDebugMode) {
      developer.log(
        'USER: $message${screen != null ? ' - Screen: $screen' : ''}${action != null ? ' - Action: $action' : ''}',
        name: '${_tag}_USER',
        level: 800,
      );
    }
  }
}
