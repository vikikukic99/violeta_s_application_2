import 'package:flutter/material.dart';

/// Quick accessors used across the app
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable
class ThemeHelper {
  /// Current theme key
  var _appTheme = 'lightCode';

  /// Custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  /// Color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  /// Returns the LightCode colors for the current theme.
  LightCodeColors _getThemeColors() =>
      _supportedCustomColor[_appTheme] ?? LightCodeColors();

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    final colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;

    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      useMaterial3: false,
    );
  }

  /// Public getters
  LightCodeColors themeColor() => _getThemeColors();
  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = const ColorScheme.light();
}

/// Centralized palette used by the app.  
/// Keep names stable to match existing references (e.g. blue_gray_600).
class LightCodeColors {
  // ----- Brand / Primary -----
  Color get green_500 => const Color(0xFF4CAF50);
  Color get green_600 => const Color(0xFF16A34A); // used in detail chips
  Color get green_700 => const Color(0xFF16A34A);
  Color get green_800 => const Color(0xFF15803D);
  Color get green_A700 => const Color(0xFF22C55E);
  Color get green_100 => const Color(0xFFDCFCE7); // soft green bg
  Color get green_50  => const Color(0xFFDCFCE7);

  // ----- Neutral / Blue Gray scale -----
  Color get blue_gray_900 => const Color(0xFF1F2937);
  Color get blue_gray_800 => const Color(0xFF374151);
  Color get blue_gray_700 => const Color(0xFF4B5563);
  Color get blue_gray_600 => const Color(0xFF64748B); // <-- added (missing)
  Color get blue_gray_300 => const Color(0xFF9CA3AF);
  Color get blue_gray_200 => const Color(0xFFADAEBC);
  Color get blue_gray_100 => const Color(0xFFD1D5DB);
  Color get blue_gray_100_01 => const Color(0xFFCED4DA);
  Color get blue_gray_100_02 => const Color(0xFFCBCBCB);
  Color get blue_gray_100_99 => const Color(0x99D9D9D9);

  // ----- Basic colors -----
  Color get white_A700 => const Color(0xFFFFFFFF);
  Color get white_A700_01 => const Color(0xFFFCFDFF);
  Color get black_900 => const Color(0xFF000000);
  Color get red_A700 => const Color(0xFFFF0000);
  Color get red_50 => const Color(0xFFFEF2F2);
  Color get red_300 => const Color(0xFFFCA5A5);
  Color get red_500 => const Color(0xFFEF4444);
  Color get red_700 => const Color(0xFFB91C1C);
  Color get blue_gray_400 => const Color(0xFF94A3B8);
  Color get green_300 => const Color(0xFF86EFAC);

  // ----- Grays -----
  Color get gray_50   => const Color(0xFFF9FAFB);
  Color get gray_100  => const Color(0xFFF3F4F6);
  Color get gray_100_01 => const Color(0xFFEFF6FF);
  Color get gray_100_02 => const Color(0xFFF0FDF4);
  Color get gray_200  => const Color(0xFFE5E7EB);
  Color get gray_600  => const Color(0xFF6B7280);

  // ----- Accent blues / teals -----
  Color get indigo_A400   => const Color(0xFF4F46E5);
  Color get blue_300      => const Color(0xFF60A5FA);
  Color get blue_50       => const Color(0xFFEEF2FF);
  Color get blue_50_01    => const Color(0xFFDBEAFE);
  Color get blue_A200     => const Color(0xFF3B82F6);
  Color get blue_A200_01  => const Color(0xFF4285F4);
  Color get blue_A700     => const Color(0xFF2563EB);
  Color get light_blue_800 => const Color(0xFF0070BA);
  Color get teal_A700     => const Color(0xFF14B8A6);
  Color get teal_400      => const Color(0xFF10B981);

  // ----- Ambers / Yellows -----
  Color get amber_300_33 => const Color(0x33FFD54F);
  Color get amber_500    => const Color(0xFFFFC107);
  Color get amber_700    => const Color(0xFFF59E0B);
  Color get amber_800    => const Color(0xFFFF8F00);
  Color get yellow_50    => const Color(0xFFFEFCE8);

  // ----- Other accents -----
  Color get deep_orange_A700 => const Color(0xFFFA1616);

  // ----- Utility / misc -----
  Color get transparentCustom => Colors.transparent;
  Color get whiteCustom => Colors.white;
  Color get blackCustom => Colors.black;
  Color get greyCustom => Colors.grey;

  // Shadows / overlays
  Color get color0C0000 => const Color(0x0C000000);
  Color get color190000 => const Color(0x19000000);
  Color get color33FFFF => const Color(0x33FFFFFF);
  Color get colorE5FFFF => const Color(0xE5FFFFFF);
  Color get colorE5194F => const Color(0xE5194F46);
  Color get colorFFEF44 => const Color(0xFFEF4444);

  // Material shades (convenience)
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;

  // Aliases used by older code paths
  Color get whiteA700 => white_A700;
  Color get whiteA70001 => white_A700_01;
  Color get green100 => green_100;
  Color get gray700 => const Color(0xFF374151);
}
