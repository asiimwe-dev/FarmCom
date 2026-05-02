import 'package:flutter/material.dart';

/// FarmLink UG Typography - Premium font family optimized for iOS feel
/// Uses system fonts for professional appearance across all platforms
class AppTypography {
  static const double _scale = 1.15;
  static const String _fontFamily = '-apple-system'; // iOS/macOS system font
  static const String _fontFamilyFallback = 'sans-serif'; // Android fallback

  // ============ Display Sizes (Large Headlines) ============
  static final TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 57 * _scale,
    fontWeight: FontWeight.w800,
    height: 1.12,
    letterSpacing: -0.5,
  );

  static final TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 45 * _scale,
    fontWeight: FontWeight.w800,
    height: 1.16,
    letterSpacing: -0.25,
  );

  static final TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.22,
    letterSpacing: 0,
  );

  // ============ Headline Sizes ============
  static final TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.15,
  );

  static final TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: 0.1,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0.1,
  );

  // ============ Title Sizes ============
  static final TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.27,
    letterSpacing: 0,
  );

  static final TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static final TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14 * _scale,
    fontWeight: FontWeight.w700,
    height: 1.43,
    letterSpacing: 0.1,
  );

  // ============ Body Sizes ============
  static final TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16 * _scale,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14 * _scale,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12 * _scale,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.4,
  );

  // ============ Label Sizes ============
  static final TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14 * _scale,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static final TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12 * _scale,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static final TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11 * _scale,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0.5,
  );

  // ============ Caption Sizes ============
  static final TextStyle captionLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12 * _scale,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.4,
  );

  static final TextStyle captionSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10 * _scale,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.3,
  );

  /// Get Material 3 TextTheme with all styles
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

  /// Apply font size multiplier to any TextStyle
  static TextStyle applyMultiplier(TextStyle style, double multiplier) {
    final currentSize = style.fontSize ?? 14.0;
    return style.copyWith(fontSize: currentSize * multiplier);
  }

  /// Helper to get theme text style with multiplier applied
  static TextStyle getDisplayLarge(double multiplier) => applyMultiplier(displayLarge, multiplier);
  static TextStyle getDisplayMedium(double multiplier) => applyMultiplier(displayMedium, multiplier);
  static TextStyle getDisplaySmall(double multiplier) => applyMultiplier(displaySmall, multiplier);
  static TextStyle getHeadlineLarge(double multiplier) => applyMultiplier(headlineLarge, multiplier);
  static TextStyle getHeadlineMedium(double multiplier) => applyMultiplier(headlineMedium, multiplier);
  static TextStyle getHeadlineSmall(double multiplier) => applyMultiplier(headlineSmall, multiplier);
  static TextStyle getTitleLarge(double multiplier) => applyMultiplier(titleLarge, multiplier);
  static TextStyle getTitleMedium(double multiplier) => applyMultiplier(titleMedium, multiplier);
  static TextStyle getTitleSmall(double multiplier) => applyMultiplier(titleSmall, multiplier);
  static TextStyle getBodyLarge(double multiplier) => applyMultiplier(bodyLarge, multiplier);
  static TextStyle getBodyMedium(double multiplier) => applyMultiplier(bodyMedium, multiplier);
  static TextStyle getBodySmall(double multiplier) => applyMultiplier(bodySmall, multiplier);
  static TextStyle getLabelLarge(double multiplier) => applyMultiplier(labelLarge, multiplier);
  static TextStyle getLabelMedium(double multiplier) => applyMultiplier(labelMedium, multiplier);
  static TextStyle getLabelSmall(double multiplier) => applyMultiplier(labelSmall, multiplier);
}
