import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class Logger {
  static const String _tag = 'SparkaleApp';
  
  // Debug log
  static void d(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _tag,
        level: 500, // Debug level
      );
    }
  }
  
  // Info log
  static void i(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _tag,
        level: 800, // Info level
      );
    }
  }
  
  // Warning log
  static void w(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _tag,
        level: 900, // Warning level
      );
    }
  }
  
  // Error log
  static void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? _tag,
        level: 1000, // Error level
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
  
  // API log
  static void api(String message, {String? endpoint, Map<String, dynamic>? data}) {
    if (kDebugMode) {
      developer.log(
        'API: $message${endpoint != null ? ' - $endpoint' : ''}${data != null ? ' - Data: $data' : ''}',
        name: '${_tag}_API',
        level: 800,
      );
    }
  }
  
  // Network log
  static void network(String message, {String? url, int? statusCode}) {
    if (kDebugMode) {
      developer.log(
        'NETWORK: $message${url != null ? ' - $url' : ''}${statusCode != null ? ' - Status: $statusCode' : ''}',
        name: '${_tag}_NETWORK',
        level: 800,
      );
    }
  }
  
  // Database log
  static void db(String message, {String? table, String? operation}) {
    if (kDebugMode) {
      developer.log(
        'DB: $message${table != null ? ' - Table: $table' : ''}${operation != null ? ' - Operation: $operation' : ''}',
        name: '${_tag}_DB',
        level: 800,
      );
    }
  }
  
  // User action log
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
