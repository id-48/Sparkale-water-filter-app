import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/logger.dart';

class ClarityService extends GetxService {
  static ClarityService get to => Get.find();
  
  bool _isInitialized = false;
  BuildContext? _context;
  
  /// Initialize Clarity with project configuration
  Future<void> initialize({
    required String projectId,
    bool enableCrashReporting = true,
    bool enableLogging = true,
  }) async {
    try {
      if (_isInitialized) {
        Logger.w('Clarity is already initialized');
        return;
      }
      
      // Note: Clarity requires a BuildContext for initialization
      // This will be called from the main app widget
      Logger.i('Clarity service initialized with project ID: $projectId');
      _isInitialized = true;
    } catch (e) {
      Logger.e('Failed to initialize Clarity', error: e);
      rethrow;
    }
  }
  
  /// Initialize Clarity with BuildContext (called from main app)
  bool initializeWithContext(BuildContext context, String projectId) {
    try {
      if (_isInitialized && _context != null) {
        Logger.w('Clarity is already initialized with context');
        return true;
      }
      
      _context = context;
      
      final clarityConfig = ClarityConfig(
        projectId: projectId,
        logLevel: LogLevel.Info,
      );
      
      final success = Clarity.initialize(context, clarityConfig);
      
      if (success) {
        _isInitialized = true;
        // Set a custom user ID after initialization
        Clarity.setCustomUserId('user_${DateTime.now().millisecondsSinceEpoch}');
        Logger.i('Clarity initialized successfully with project ID: $projectId');
      } else {
        Logger.e('Failed to initialize Clarity with context');
      }
      
      return success;
    } catch (e) {
      Logger.e('Failed to initialize Clarity with context', error: e);
      return false;
    }
  }
  
  /// Track custom events
  void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    try {
      if (!_isInitialized) {
        Logger.w('Clarity not initialized. Cannot track event: $eventName');
        return;
      }
      
      // Clarity only supports simple string events
      final eventValue = properties != null 
          ? '$eventName: ${properties.toString()}'
          : eventName;
      
      final success = Clarity.sendCustomEvent(eventValue);
      if (success) {
        Logger.d('Event tracked: $eventName with properties: $properties');
      } else {
        Logger.w('Failed to track event: $eventName');
      }
    } catch (e) {
      Logger.e('Failed to track event: $eventName', error: e);
    }
  }
  
  /// Set user properties (as custom tags)
  void setUserProperties(Map<String, dynamic> properties) {
    try {
      if (!_isInitialized) {
        Logger.w('Clarity not initialized. Cannot set user properties');
        return;
      }
      
      properties.forEach((key, value) {
        Clarity.setCustomTag(key, value.toString());
      });
      Logger.d('User properties set: $properties');
    } catch (e) {
      Logger.e('Failed to set user properties', error: e);
    }
  }
  
  /// Set user ID
  void setUserId(String userId) {
    try {
      if (!_isInitialized) {
        Logger.w('Clarity not initialized. Cannot set user ID');
        return;
      }
      
      final success = Clarity.setCustomUserId(userId);
      if (success) {
        Logger.d('User ID set: $userId');
      } else {
        Logger.w('Failed to set user ID: $userId');
      }
    } catch (e) {
      Logger.e('Failed to set user ID', error: e);
    }
  }
  
  /// Track screen views
  void trackScreenView(String screenName, {Map<String, dynamic>? properties}) {
    try {
      if (!_isInitialized) {
        Logger.w('Clarity not initialized. Cannot track screen view');
        return;
      }
      
      final success = Clarity.setCurrentScreenName(screenName);
      if (success) {
        Logger.d('Screen view tracked: $screenName with properties: $properties');
      } else {
        Logger.w('Failed to track screen view: $screenName');
      }
    } catch (e) {
      Logger.e('Failed to track screen view: $screenName', error: e);
    }
  }
  
  /// Track user actions
  void trackUserAction(String action, {Map<String, dynamic>? properties}) {
    trackEvent('user_action_$action', properties: properties);
  }
  
  /// Track app lifecycle events
  void trackAppLifecycle(String lifecycleEvent) {
    trackEvent('app_lifecycle_$lifecycleEvent');
  }
  
  /// Track authentication events
  void trackAuthEvent(String authEvent, {String? userId, Map<String, dynamic>? properties}) {
    final eventProperties = {
      'auth_event': authEvent,
      if (userId != null) 'user_id': userId,
      ...?properties,
    };
    trackEvent('auth_$authEvent', properties: eventProperties);
  }
  
  /// Track navigation events
  void trackNavigation(String fromScreen, String toScreen, {Map<String, dynamic>? properties}) {
    final navProperties = {
      'from_screen': fromScreen,
      'to_screen': toScreen,
      ...?properties,
    };
    trackEvent('navigation', properties: navProperties);
  }
  
  /// Track feature usage
  void trackFeatureUsage(String featureName, {Map<String, dynamic>? properties}) {
    trackEvent('feature_usage_$featureName', properties: properties);
  }
  
  /// Track errors
  void trackError(String errorType, String errorMessage, {Map<String, dynamic>? properties}) {
    final errorProperties = {
      'error_type': errorType,
      'error_message': errorMessage,
      ...?properties,
    };
    trackEvent('error_$errorType', properties: errorProperties);
  }
  
  /// Check if Clarity is initialized
  bool get isInitialized => _isInitialized;
}
