/// Standardized spacing values for consistent 8pt grid layout across FarmLink UG
/// 
/// Uses multiples of 4pt for finer control and 8pt for major sections
/// This ensures visual consistency and makes the app easier to maintain
class SpacingConstants {
  /// Extra small - used for tight spacing between elements (e.g., icon + text)
  static const double xs = 4.0;

  /// Small - standard spacing between related elements
  static const double sm = 8.0;

  /// Medium - spacing between sections
  static const double md = 12.0;

  /// Standard - main spacing between components
  static const double lg = 16.0;

  /// Large - spacing between major sections
  static const double xl = 20.0;

  /// Extra large - generous spacing for top-level sections
  static const double xxl = 24.0;

  /// XXL - very large spacing between different page sections
  static const double xxxl = 32.0;

  /// XXXL - maximum spacing for critical separations
  static const double xxxxl = 40.0;

  /// Padding values
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 12.0;
  static const double paddingLG = 16.0;
  static const double paddingXL = 20.0;
  static const double paddingXXL = 24.0;
  static const double paddingXXXL = 32.0;
  static const double paddingXXXXL = 40.0;

  /// Standard padding combinations
  static const double paddingHorizontal = paddingLG;
  static const double paddingVertical = paddingLG;
  static const double paddingSymmetric = paddingXXL;

  /// Card and container spacing
  static const double cardPadding = paddingLG;
  static const double cardSpacing = paddingLG;
  static const double containerPadding = paddingXXL;

  /// List spacing
  static const double listItemSpacing = paddingMD;
  static const double listSectionSpacing = paddingXXL;

  /// Button spacing
  static const double buttonPadding = paddingLG;
  static const double buttonSpacing = paddingMD;

  /// Icon spacing
  static const double iconSpacing = paddingSM;
  static const double iconPadding = paddingMD;

  /// Text spacing
  static const double textSpacing = paddingMD;
  static const double textLineHeight = 1.5;

  /// Divider spacing
  static const double dividerSpacing = paddingLG;
}
