import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/// A flexible, animated button with optional icons on either side.
/// - Use [leftIcon]/[rightIcon] to pass asset paths (PNG/SVG) — keeps backward compatibility.
/// - Prefer [leftIconWidget]/[rightIconWidget] for *frameless* Material icons so you
///   avoid baked-in backgrounds in assets (e.g. the white square you’re seeing).
class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.leftIcon,
    this.rightIcon,
    this.leftIconWidget,
    this.rightIconWidget,
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
    this.enableIconSlide = true,
  }) : super(key: key);

  /// Button label
  final String text;

  /// Tap callback
  final VoidCallback? onPressed;

  /// (Legacy) asset paths (PNG/SVG). Prefer the Widget variants below.
  final String? leftIcon;
  final String? rightIcon;

  /// Modern, frameless icon slots (e.g., `Icon(Icons.arrow_forward_rounded)`).
  final Widget? leftIconWidget;
  final Widget? rightIconWidget;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final double? elevation;
  final bool isEnabled;

  /// If true, the right icon slides slightly on press.
  final bool enableIconSlide;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _pressed = false;

  Widget _buildLeftIcon() {
    if (widget.leftIconWidget != null) return widget.leftIconWidget!;
    if (widget.leftIcon != null) {
      return CustomImageView(
        imagePath: widget.leftIcon!,
        height: 20.h,
        width: 20.h,
        fit: BoxFit.contain,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRightIcon() {
    final child = widget.rightIconWidget ??
        (widget.rightIcon != null
            ? CustomImageView(
                imagePath: widget.rightIcon!,
                height: 20.h,
                width: 20.h,
                fit: BoxFit.contain,
              )
            : const SizedBox.shrink());

    if (!widget.enableIconSlide) return child;

    // Slide the right icon a bit when pressed for a lively feel
    return AnimatedSlide(
      duration: const Duration(milliseconds: 140),
      offset: _pressed ? const Offset(0.12, 0) : Offset.zero,
      curve: Curves.easeOut,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? appTheme.green_500;
    final radius = BorderRadius.circular(widget.borderRadius ?? 8.h);
    final shadowElevation = (widget.elevation ?? 0);
    final textStyle = TextStyleHelper.instance.textStyle30.copyWith(
      color: widget.textColor ?? appTheme.whiteCustom,
      height: 1.2,
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
      fontFamily: widget.fontFamily,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: widget.width ?? double.infinity,
      height: widget.height,
      transform: Matrix4.identity()
        ..translate(0.0, _pressed ? 1.0 : 0.0), // tiny press depth
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: widget.borderColor != null
            ? Border.all(
                color: widget.borderColor!,
                width: widget.borderWidth ?? 1.h,
              )
            : null,
        boxShadow: shadowElevation > 0
            ? [
                BoxShadow(
                  color: appTheme.blackCustom.withAlpha(_pressed ? 12 : 26),
                  blurRadius: shadowElevation,
                  offset: Offset(0, shadowElevation / 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isEnabled ? widget.onPressed : null,
          borderRadius: radius,
          onHighlightChanged: (v) {
            setState(() => _pressed = v);
          },
          child: Padding(
            padding: widget.padding ??
                EdgeInsets.symmetric(
                  vertical: 14.h,
                  horizontal: 18.h,
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Left icon
                if (widget.leftIcon != null || widget.leftIconWidget != null)
                  ...[
                    _buildLeftIcon(),
                    SizedBox(width: 10.h),
                  ],

                // Label
                Flexible(
                  child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),

                // Right icon
                if (widget.rightIcon != null ||
                    widget.rightIconWidget != null) ...[
                  SizedBox(width: 10.h),
                  _buildRightIcon(),
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
