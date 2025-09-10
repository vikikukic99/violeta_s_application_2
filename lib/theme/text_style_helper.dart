import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Display Styles
  // Large text styles typically used for headers and hero elements

  TextStyle get display50BoldPoppins => TextStyle(
        fontSize: 50.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      );

  TextStyle get display36BoldPoppins => TextStyle(
        fontSize: 36.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_900,
      );

  // Headline Styles
  // Medium-large text styles for section headers

  TextStyle get headline30BoldInter => TextStyle(
        fontSize: 30.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
        color: appTheme.blue_gray_900,
      );

  TextStyle get headline30BoldPoppins => TextStyle(
        fontSize: 30.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
        color: appTheme.white_A700,
      );

  TextStyle get headline24BoldInter => TextStyle(
        fontSize: 24.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
        color: appTheme.blue_gray_900,
      );

  TextStyle get headline24BoldPoppins => TextStyle(
        fontSize: 24.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
        color: appTheme.green_500,
      );

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      );

  TextStyle get title20SemiBoldPoppins => TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_900,
      );

  TextStyle get title20BoldPoppins => TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_900,
      );

  TextStyle get title20SemiBoldInter => TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
        color: appTheme.blue_gray_900,
      );

  TextStyle get title20BoldInter => TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Inter',
        color: appTheme.blue_gray_900,
      );

  TextStyle get title18SemiBoldInter => TextStyle(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
        color: appTheme.blue_gray_900,
      );

  TextStyle get title18RegularPoppins => TextStyle(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_700,
      );

  TextStyle get title16RegularInter => TextStyle(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
      );

  TextStyle get title16MediumInter => TextStyle(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      );

  TextStyle get title16SemiBoldInter => TextStyle(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
        color: appTheme.blue_gray_900,
      );

  TextStyle get title16RegularPoppins => TextStyle(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      );

  TextStyle get title16SemiBoldPoppins => TextStyle(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_900,
      );

  TextStyle get title16MediumPoppins => TextStyle(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: appTheme.green_500,
      );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body14MediumInter => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      );

  TextStyle get body14RegularInter => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        color: appTheme.blue_gray_800,
      );

  TextStyle get body14MediumPoppins => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_800,
      );

  TextStyle get body14RegularPoppins => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      );

  TextStyle get body14SemiBoldInter => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
        color: appTheme.blue_gray_800,
      );

  TextStyle get body12RegularInter => TextStyle(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
        color: appTheme.gray_600,
      );

  TextStyle get body12RegularPoppins => TextStyle(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
        color: appTheme.gray_600,
      );

  TextStyle get body12MediumPoppins => TextStyle(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      );

  TextStyle get body12MediumInter => TextStyle(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      );

  TextStyle get body12Inter => TextStyle(
        fontSize: 12.fSize,
        fontFamily: 'Inter',
      );

  // Other Styles
  // Miscellaneous text styles without specified font size

  TextStyle get bodyTextInter => TextStyle(
        fontFamily: 'Inter',
      );

  TextStyle get textStyle30 => TextStyle();

  // Fix for missing text styles used in edit_profile_screen
  TextStyle get titleMediumPoppins => TextStyle(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_900,
      );

  TextStyle get labelLargePoppins => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_900,
      );

  TextStyle get titleSmallPoppins => TextStyle(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_900,
      );

  TextStyle get bodyMediumGreenA700 => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: appTheme.green_A700,
      );

  TextStyle get bodyMediumGray700 => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_700,
      );

  // Add missing text style for activity card widget
  TextStyle get title14MediumPoppins => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: appTheme.blue_gray_900,
      );
}
