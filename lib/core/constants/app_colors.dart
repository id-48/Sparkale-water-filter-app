import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2176DA);
  static const Color primaryDark = Color(0xFF1B66C1);
  static const Color primaryLight = Color(0xFF6697D3);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryDark = Color(0xFF018786);
  static const Color secondaryLight = Color(0xFF80CBC4);


  // Water Theme Colors
  static const Color waterBlue = Color(0xFFE9EFFD);
  static const Color waterBlueDark = Color(0xFFE9EFFD);
  static const Color waterBlueLight = Color(0xFFE9EFFD);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transprent = Color(0x0);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyDark = Color(0xFF616161);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successToastText = Color(0xFF027A48);
  static const Color successToastBg = Color(0xFF6CE9A6);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color errorToastBg = Color(0xFFF43F5E);
  static const Color info = Color(0xFF2196F3);


  
  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF344054);
  static const Color textHint = Color(0xFF344054);
  static const Color textDisabled = Color(0xFFE0E0E0);
  
  // Border Colors
  static const Color border = Color(0xFFD0D5DD);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color borderDark = Color(0xFFBDBDBD);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient waterGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [waterBlueLight, waterBlue, waterBlueDark],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, greyLight],
  );
}
