import 'package:flutter/material.dart';

/// FarmCom Typography - Urbanist font family
/// Scaled at 1.2x for high readability in rural contexts
class AppTypography {
  static const double _scale = 1.2;

  // Display sizes
  static final TextStyle displayLarge = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 57 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.12,
    letterSpacing: 0,
  );

  static final TextStyle displayMedium = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 45 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.16,
    letterSpacing: 0,
  );

  static final TextStyle displaySmall = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 36 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.22,
    letterSpacing: 0,
  );

  // Headline sizes
  static final TextStyle headlineLarge = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 32 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0,
  );

  static final TextStyle headlineMedium = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 28 * _scale,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: 0,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 24 * _scale,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
  );

  // Title sizes
  static final TextStyle titleLarge = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 22 * _scale,
    fontWeight: FontWeight.w600,
    height: 1.27,
    letterSpacing: 0,
  );

  static final TextStyle titleMedium = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 16 * _scale,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static final TextStyle titleSmall = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 14 * _scale,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
  );

  // Body sizes
  static final TextStyle bodyLarge = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 16 * _scale,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 14 * _scale,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 12 * _scale,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
  );

  // Label sizes
  static final TextStyle labelLarge = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 14 * _scale,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static final TextStyle labelMedium = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 12 * _scale,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static final TextStyle labelSmall = TextStyle(
    fontFamily: 'Urbanist',
    fontSize: 11 * _scale,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
  );

  /// Get Material 3 TextTheme
  static TextTheme getTextTheme() {
    return TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}
