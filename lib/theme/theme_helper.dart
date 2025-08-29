import 'package:flutter/material.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = "lightCode";

  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light();
}

class LightCodeColors {
  // App Colors
  Color get green_500 => Color(0xFF4CAF50);
  Color get blue_gray_900 => Color(0xFF1F2937);
  Color get blue_gray_700 => Color(0xFF4B5563);
  Color get blue_gray_300 => Color(0xFF9CA3AF);
  Color get blue_gray_200 => Color(0xFFADAEBC);
  Color get blue_gray_100 => Color(0xFFD1D5DB);
  Color get white_A700 => Color(0xFFFFFFFF);
  Color get red_A700 => Color(0xFFFF0000);
  Color get black_900 => Color(0xFF000000);
  Color get gray_600 => Color(0xFF6B7280);
  Color get blue_gray_100_01 => Color(0xFFCED4DA);
  Color get gray_50 => Color(0xFFF9FAFB);
  Color get indigo_A400 => Color(0xFF4F46E5);
  Color get blue_gray_800 => Color(0xFF374151);
  Color get gray_100 => Color(0xFFF3F4F6);
  Color get amber_800 => Color(0xFFFF8F00);
  Color get amber_300_33 => Color(0x33FFD54F);
  Color get amber_500 => Color(0xFFFFC107);
  Color get green_800 => Color(0xFF15803D);
  Color get green_50 => Color(0xFFDCFCE7);
  Color get blue_300 => Color(0xFF60A5FA);
  Color get amber_700 => Color(0xFFF59E0B);
  Color get green_A700 => Color(0xFF22C55E);
  Color get gray_200 => Color(0xFFE5E7EB);
  Color get blue_50 => Color(0xFFEEF2FF);
  Color get blue_A200 => Color(0xFF3B82F6);
  Color get teal_A700 => Color(0xFF14B8A6);
  Color get teal_400 => Color(0xFF10B981);
  Color get deep_orange_A700 => Color(0xFFFA1616);
  Color get blue_A700 => Color(0xFF2563EB);
  Color get gray_100_01 => Color(0xFFEFF6FF);
  Color get green_700 => Color(0xFF16A34A);
  Color get gray_100_02 => Color(0xFFF0FDF4);
  Color get yellow_50 => Color(0xFFFEFCE8);
  Color get blue_50_01 => Color(0xFFDBEAFE);
  Color get light_blue_800 => Color(0xFF0070BA);
  Color get blue_A200_01 => Color(0xFF4285F4);
  Color get white_A700_01 => Color(0xFFFCFDFF);
  Color get blue_gray_100_99 => Color(0x99D9D9D9);
  Color get blue_gray_100_02 => Color(0xFFCBCBCB);

  // Additional Colors
  Color get transparentCustom => Colors.transparent;
  Color get whiteCustom => Colors.white;
  Color get blackCustom => Colors.black;
  Color get greyCustom => Colors.grey;
  Color get color0C0000 => Color(0x0C000000);
  Color get colorE5194F => Color(0xE5194F46);
  Color get color190000 => Color(0x19000000);
  Color get color33FFFF => Color(0x33FFFFFF);
  Color get colorE5FFFF => Color(0xE5FFFFFF);
  Color get colorFFEF44 => Color(0xFFEF4444);

  // Color Shades - Each shade has its own dedicated constant
  Color get grey200 => Colors.grey.shade200;
  Color get grey100 => Colors.grey.shade100;

  // Fix for missing colors used in edit_profile_screen
  Color get whiteA700 => white_A700;
  Color get whiteA70001 => white_A700; // Fix for missing color
  Color get green100 => Color(0xFFDCFCE7);
  Color get gray700 => Color(0xFF374151);
}
