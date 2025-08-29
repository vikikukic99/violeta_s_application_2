import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomEditText - A flexible and reusable text input component
 * 
 * This component provides a customizable TextFormField that supports:
 * - Left and right icons/images
 * - Various input types (text, email, password, date)
 * - Custom styling (borders, backgrounds, text styles)
 * - Validation support
 * - Responsive design
 * - Password visibility toggle
 * - Date picker integration
 * 
 * @param controller - TextEditingController for managing input
 * @param hintText - Placeholder text to display
 * @param validator - Function for input validation
 * @param inputType - Keyboard type for different input modes
 * @param isPassword - Whether this is a password field
 * @param leftIcon - Icon/image to display on the left side
 * @param rightIcon - Icon/image to display on the right side
 * @param borderColor - Color of the input border
 * @param backgroundColor - Background color of the input
 * @param textColor - Color of the input text
 * @param hintTextColor - Color of the placeholder text
 * @param borderRadius - Border radius of the input
 * @param borderWidth - Width of the input border
 * @param contentPadding - Internal padding of the input
 * @param fontSize - Font size of the text
 * @param fontWeight - Font weight of the text
 * @param onTap - Callback for tap events (useful for date pickers)
 * @param readOnly - Whether the field is read-only
 * @param enabled - Whether the field is enabled
 */
class CustomEditText extends StatefulWidget {
  CustomEditText({
    Key? key,
    this.controller,
    this.hintText,
    this.validator,
    this.inputType,
    this.isPassword,
    this.leftIcon,
    this.rightIcon,
    this.borderColor,
    this.backgroundColor,
    this.textColor,
    this.hintTextColor,
    this.borderRadius,
    this.borderWidth,
    this.contentPadding,
    this.fontSize,
    this.fontWeight,
    this.onTap,
    this.readOnly,
    this.enabled,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final bool? isPassword;
  final String? leftIcon;
  final String? rightIcon;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? hintTextColor;
  final double? borderRadius;
  final double? borderWidth;
  final EdgeInsetsGeometry? contentPadding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final VoidCallback? onTap;
  final bool? readOnly;
  final bool? enabled;

  @override
  State<CustomEditText> createState() => _CustomEditTextState();
}

class _CustomEditTextState extends State<CustomEditText> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.inputType ?? TextInputType.text,
      obscureText: widget.isPassword == true ? !_isPasswordVisible : false,
      onTap: widget.onTap,
      readOnly: widget.readOnly ?? false,
      enabled: widget.enabled ?? true,
      style: TextStyleHelper.instance.bodyTextInter
          .copyWith(color: widget.textColor ?? Color(0xFF1F2937)),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyleHelper.instance.bodyTextInter
            .copyWith(color: widget.hintTextColor ?? Color(0xFFADAEBC)),
        filled: true,
        fillColor: widget.backgroundColor ?? Color(0xFFFFFFFF),
        contentPadding: widget.contentPadding ?? EdgeInsets.all(12.h),
        prefixIcon: widget.leftIcon != null
            ? Padding(
                padding: EdgeInsets.all(12.h),
                child: CustomImageView(
                  imagePath: widget.leftIcon!,
                  height: 24.h,
                  width: 24.h,
                ),
              )
            : null,
        suffixIcon: _buildSuffixIcon(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius?.h ?? 8.h),
          borderSide: BorderSide(
            color: widget.borderColor ?? Color(0xFFD1D5DB),
            width: widget.borderWidth?.h ?? 1.h,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius?.h ?? 8.h),
          borderSide: BorderSide(
            color: widget.borderColor ?? Color(0xFFD1D5DB),
            width: widget.borderWidth?.h ?? 1.h,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius?.h ?? 8.h),
          borderSide: BorderSide(
            color: widget.borderColor ?? Color(0xFF4CAF50),
            width: widget.borderWidth?.h ?? 2.h,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius?.h ?? 8.h),
          borderSide: BorderSide(
            color: appTheme.colorFFEF44,
            width: widget.borderWidth?.h ?? 1.h,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius?.h ?? 8.h),
          borderSide: BorderSide(
            color: appTheme.colorFFEF44,
            width: widget.borderWidth?.h ?? 2.h,
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.isPassword == true) {
      return IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: widget.hintTextColor ?? Color(0xFFADAEBC),
          size: 24.h,
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      );
    } else if (widget.rightIcon != null) {
      return Padding(
        padding: EdgeInsets.all(12.h),
        child: CustomImageView(
          imagePath: widget.rightIcon!,
          height: 24.h,
          width: 24.h,
        ),
      );
    }
    return null;
  }
}
