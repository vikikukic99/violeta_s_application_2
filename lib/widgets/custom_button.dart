import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * A customizable button widget that supports various styles, icons, and layouts.
 * 
 * This widget provides a flexible button implementation that can handle:
 * - Text-only buttons
 * - Buttons with left or right icons
 * - Various background colors and border styles
 * - Different padding and sizing options
 * - Custom text styles and colors
 * - Navigation and callback functionality
 * - Responsive design across different screen sizes
 * 
 * @param text - The button text content (required)
 * @param onPressed - Callback function when button is tapped
 * @param leftIcon - Path to left icon image (SVG/PNG)
 * @param rightIcon - Path to right icon image (SVG/PNG)
 * @param backgroundColor - Background color of the button
 * @param textColor - Color of the button text
 * @param borderColor - Color of the button border
 * @param borderWidth - Width of the button border
 * @param borderRadius - Border radius of the button
 * @param fontSize - Font size of the button text
 * @param fontWeight - Font weight of the button text
 * @param fontFamily - Font family of the button text
 * @param padding - Custom padding for the button
 * @param width - Width behavior of the button
 * @param height - Custom height for the button
 * @param elevation - Shadow elevation of the button
 * @param isEnabled - Whether the button is enabled or disabled
 */
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.leftIcon,
    this.rightIcon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.padding,
    this.width,
    this.height,
    this.elevation,
    this.isEnabled = true,
  }) : super(key: key);

  /// The text content of the button
  final String text;

  /// Callback function triggered when button is pressed
  final VoidCallback? onPressed;

  /// Path to the left icon image
  final String? leftIcon;

  /// Path to the right icon image
  final String? rightIcon;

  /// Background color of the button
  final Color? backgroundColor;

  /// Text color of the button
  final Color? textColor;

  /// Border color of the button
  final Color? borderColor;

  /// Width of the button border
  final double? borderWidth;

  /// Border radius of the button
  final double? borderRadius;

  /// Font size of the button text
  final double? fontSize;

  /// Font weight of the button text
  final FontWeight? fontWeight;

  /// Font family of the button text
  final String? fontFamily;

  /// Custom padding for the button
  final EdgeInsets? padding;

  /// Width behavior of the button
  final double? width;

  /// Custom height for the button
  final double? height;

  /// Shadow elevation of the button
  final double? elevation;

  /// Whether the button is enabled
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? appTheme.transparentCustom,
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? 1.h,
              )
            : null,
        borderRadius: BorderRadius.circular(borderRadius ?? 8.h),
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: appTheme.blackCustom.withAlpha(26),
                  blurRadius: elevation!,
                  offset: Offset(0, elevation! / 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: appTheme.transparentCustom,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius ?? 8.h),
          child: Container(
            padding: padding ??
                EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 30.h,
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leftIcon != null) ...[
                  CustomImageView(
                    imagePath: leftIcon!,
                    height: 20.h,
                    width: 20.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 8.h),
                ],
                Flexible(
                  child: Text(
                    text,
                    style: TextStyleHelper.instance.textStyle30.copyWith(
                        color: textColor ?? appTheme.whiteCustom, height: 1.2),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (rightIcon != null) ...[
                  SizedBox(width: 8.h),
                  CustomImageView(
                    imagePath: rightIcon!,
                    height: 20.h,
                    width: 20.h,
                    fit: BoxFit.contain,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonStyles {
  // Base button styles
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
        backgroundColor: appTheme.green_500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get outlineBlueGray => ElevatedButton.styleFrom(
        backgroundColor: appTheme.white_A700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
          side: BorderSide(
            color: appTheme.blue_gray_300,
            width: 1,
          ),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get fillWhite => ElevatedButton.styleFrom(
        backgroundColor: appTheme.white_A700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get fillGray => ElevatedButton.styleFrom(
        backgroundColor: appTheme.gray_200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
}
