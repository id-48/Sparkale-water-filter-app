import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        tertiary: AppColors.accent,
        onTertiary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: AppConstants.largeFontSize,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
        margin: const EdgeInsets.all(AppConstants.smallPadding),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.defaultPadding,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.mediumFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.defaultPadding,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.greyLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.defaultPadding,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textHint,
          fontSize: AppConstants.defaultFontSize,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppConstants.defaultFontSize,
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.titleFontSize,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.extraLargeFontSize,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.largeFontSize,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.largeFontSize,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.mediumFontSize,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.defaultFontSize,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.mediumFontSize,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.defaultFontSize,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.smallFontSize,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.mediumFontSize,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.defaultFontSize,
        ),
        bodySmall: TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppConstants.smallFontSize,
        ),
        labelLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: AppConstants.defaultFontSize,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: AppConstants.smallFontSize,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: AppColors.textHint,
          fontSize: AppConstants.smallFontSize,
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: AppConstants.defaultIconSize,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
      ),
      
      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: AppConstants.defaultFontSize,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        secondary: AppColors.secondary,
        onSecondary: AppColors.white,
        tertiary: AppColors.accent,
        onTertiary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.white,
        surface: Color(0xFF1E1E1E),
        onSurface: AppColors.white,
        background: Color(0xFF121212),
        onBackground: AppColors.white,
      ),
      
      // Similar theme configurations for dark mode...
      // (Implementation would be similar to light theme but with dark colors)
    );
  }
}
