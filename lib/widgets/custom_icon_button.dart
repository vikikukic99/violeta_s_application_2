import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * A customizable icon button widget with configurable appearance and behavior.
 * 
 * This widget provides a flexible icon button implementation with support for:
 * - Custom icons from various sources (SVG, PNG, network images)
 * - Configurable background colors
 * - Adjustable border radius and padding
 * - Multiple size presets
 * - Touch feedback and navigation handling
 * 
 * @param iconPath - Path to the icon image (required)
 * @param backgroundColor - Background color of the button
 * @param size - Size of the button (width and height)
 * @param borderRadius - Corner radius of the button
 * @param padding - Internal padding of the button
 * @param onTap - Callback function when button is tapped
 */
class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    required this.iconPath,
    this.backgroundColor,
    this.size,
    this.borderRadius,
    this.padding,
    this.onTap,
  }) : super(key: key);

  /// Path to the icon image (SVG, PNG, network URL, etc.)
  final String iconPath;

  /// Background color of the button
  final Color? backgroundColor;

  /// Size of the button (both width and height)
  final double? size;

  /// Border radius for rounded corners
  final double? borderRadius;

  /// Internal padding of the button
  final EdgeInsetsGeometry? padding;

  /// Callback function triggered when button is tapped
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 48.h;
    final buttonBorderRadius = borderRadius ?? 12.h;
    final buttonPadding = padding ?? EdgeInsets.all(8.h);
    final buttonBackgroundColor = backgroundColor ?? appTheme.grey200;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        padding: buttonPadding,
        decoration: BoxDecoration(
          color: buttonBackgroundColor,
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
        child: CustomImageView(
          imagePath: iconPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
