import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmlink_ug/core/theme/theme_provider.dart';
import 'package:farmlink_ug/core/theme/app_typography.dart';

/// Extension to easily apply theme multiplier to AppTypography styles
extension AppTypographyWithMultiplier on AppTypography {
  static TextStyle applyThemeMultiplier(BuildContext context, TextStyle baseStyle) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: baseStyle.fontSize,
          fontWeight: baseStyle.fontWeight,
          letterSpacing: baseStyle.letterSpacing,
          height: baseStyle.height,
        ) ??
        baseStyle;
  }
}

/// Helper function to get theme-aware typography with multiplier applied
TextStyle getThemeAwareTypography(
  TextStyle baseStyle,
  double multiplier,
) {
  return AppTypography.applyMultiplier(baseStyle, multiplier);
}

/// Consumer widget wrapper for easy access to theme multiplier in widgets
class ThemedText extends ConsumerWidget {
  final String text;
  final TextStyle Function(double) styleBuilder;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const ThemedText(
    this.text, {
    required this.styleBuilder,
    this.maxLines,
    this.overflow,
    this.textAlign,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final style = styleBuilder(themeState.fontSizeMultiplier);

    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
