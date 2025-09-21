class AppConstants {
  // API Configuration
  static const int apiTimeout = 30000; // 30 seconds
  static const int apiRetryAttempts = 3;
  
  // Storage Keys
  static const String storagePrefix = 'sparkale_';
  static const String selectedLanguageKey = 'selected_language';
  
  // Animation Durations
  static const int splashDuration = 3000; // 3 seconds
  static const int animationDuration = 300; // 300ms
  static const int longAnimationDuration = 600; // 600ms
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  static const double defaultRadius = 8.0;
  static const double smallRadius = 4.0;
  static const double largeRadius = 12.0;
  static const double extraLargeRadius = 16.0;
  
  // Font Sizes
  static const double smallFontSize = 12.0;
  static const double defaultFontSize = 14.0;
  static const double mediumFontSize = 16.0;
  static const double largeFontSize = 18.0;
  static const double extraLargeFontSize = 24.0;
  static const double titleFontSize = 28.0;
  
  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double defaultIconSize = 24.0;
  static const double mediumIconSize = 32.0;
  static const double largeIconSize = 48.0;
  static const double extraLargeIconSize = 64.0;
  
  // Image Sizes
  static const double smallImageSize = 40.0;
  static const double defaultImageSize = 80.0;
  static const double mediumImageSize = 120.0;
  static const double largeImageSize = 200.0;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache Duration
  static const int cacheDuration = 300; // 5 minutes
  static const int longCacheDuration = 3600; // 1 hour
}
