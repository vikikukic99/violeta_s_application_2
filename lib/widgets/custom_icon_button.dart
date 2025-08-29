import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.iconPath,
    this.backgroundColor,
    this.size,
    this.borderRadius,
    this.padding,
    this.onTap,
  }) : super(key: key);

  final String iconPath;
  final Color? backgroundColor;
  final double? size;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 48.h;
    final radius = borderRadius ?? buttonSize / 2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        padding: padding ?? EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? appTheme.grey200,
          borderRadius: BorderRadius.circular(radius),
        ),
        clipBehavior: Clip.hardEdge, // ensures no inner square lines
        child: CustomImageView(
          imagePath: iconPath,
          fit: BoxFit.contain,
        ),
      ),
    );
    }
}
