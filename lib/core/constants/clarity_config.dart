class ClarityConfig {
  // Replace with your actual Clarity project ID
  static const String projectId = 'YOUR_CLARITY_PROJECT_ID';
  
  // Clarity configuration flags
  static const bool enableCrashReporting = true;
  static const bool enableLogging = true;
  
  // Event names constants
  static const String eventLoginAttempt = 'login_attempt';
  static const String eventLoginSuccess = 'login_success';
  static const String eventLoginFailed = 'login_failed';
  static const String eventSignupAttempt = 'signup_attempt';
  static const String eventSignupSuccess = 'signup_success';
  static const String eventSignupFailed = 'signup_failed';
  static const String eventOtpSent = 'otp_sent';
  static const String eventOtpVerified = 'otp_verified';
  static const String eventOtpFailed = 'otp_failed';
  static const String eventScreenView = 'screen_view';
  static const String eventUserAction = 'user_action';
  static const String eventError = 'error';
  static const String eventNavigation = 'navigation';
  static const String eventFeatureUsage = 'feature_usage';
  
  // Screen names
  static const String screenSplash = 'splash_screen';
  static const String screenLogin = 'login_screen';
  static const String screenRegister = 'register_screen';
  static const String screenHome = 'home_screen';
  static const String screenProfile = 'profile_screen';
  static const String screenEmailVerification = 'email_verification_screen';
  static const String screenMobileVerification = 'mobile_verification_screen';
  
  // User action types
  static const String actionToggleInputType = 'toggle_input_type';
  static const String actionSelectCountry = 'select_country';
  static const String actionSendOtp = 'send_otp';
  static const String actionRefreshData = 'refresh_data';
  static const String actionNavigateToSignup = 'navigate_to_signup';
  
  // Error types
  static const String errorAuthCheck = 'auth_check_error';
  static const String errorSendOtp = 'send_otp_error';
  static const String errorRefreshData = 'refresh_data_error';
  static const String errorValidation = 'validation_error';
  static const String errorApi = 'api_error';
  static const String errorNetwork = 'network_error';
}
