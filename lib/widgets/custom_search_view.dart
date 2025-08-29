import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomSearchView - A reusable search input field component with customizable styling
 * 
 * Features:
 * - Configurable placeholder text and styling
 * - Built-in search icon with customizable asset path
 * - Form validation support
 * - Responsive design with proper scaling
 * - Date picker integration support via onTap
 * - Customizable colors and border styling
 * 
 * @param controller - TextEditingController for managing input text
 * @param placeholder - Hint text displayed when field is empty
 * @param validator - Function to validate input text
 * @param onChanged - Callback triggered when text changes
 * @param onTap - Callback for tap events (useful for date/time pickers)
 * @param keyboardType - Type of keyboard to display
 * @param suffixIconPath - Path to the suffix icon asset
 * @param fillColor - Background color of the input field
 * @param borderColor - Color of the input field border
 * @param textColor - Color of the input text
 * @param hintColor - Color of the hint text
 * @param enabled - Whether the input field is enabled
 * @param readOnly - Whether the input field is read-only
 */
class CustomSearchView extends StatelessWidget {
  const CustomSearchView({
    Key? key,
    this.controller,
    this.placeholder,
    this.validator,
    this.onChanged,
    this.onTap,
    this.keyboardType,
    this.suffixIconPath,
    this.fillColor,
    this.borderColor,
    this.textColor,
    this.hintColor,
    this.enabled,
    this.readOnly,
  }) : super(key: key);

  /// Controller for managing the text input
  final TextEditingController? controller;

  /// Placeholder text shown when field is empty
  final String? placeholder;

  /// Function to validate the input text
  final String? Function(String?)? validator;

  /// Callback function triggered when text changes
  final Function(String)? onChanged;

  /// Callback function triggered when field is tapped
  final VoidCallback? onTap;

  /// Type of keyboard to display
  final TextInputType? keyboardType;

  /// Path to the suffix icon asset
  final String? suffixIconPath;

  /// Background color of the input field
  final Color? fillColor;

  /// Border color of the input field
  final Color? borderColor;

  /// Color of the input text
  final Color? textColor;

  /// Color of the hint text
  final Color? hintColor;

  /// Whether the input field is enabled
  final bool? enabled;

  /// Whether the input field is read-only
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      keyboardType: keyboardType ?? TextInputType.text,
      enabled: enabled ?? true,
      readOnly: readOnly ?? false,
      style: TextStyleHelper.instance.title16RegularPoppins
          .copyWith(color: textColor ?? Color(0xFF374151)),
      decoration: InputDecoration(
        hintText: placeholder ?? "Search...",
        hintStyle: TextStyleHelper.instance.title16RegularPoppins
            .copyWith(color: hintColor ?? Color(0xFF9CA3AF)),
        filled: true,
        fillColor: fillColor ?? Color(0xFFFFFFFF),
        contentPadding: EdgeInsets.only(
          top: 12.h,
          right: 38.h,
          bottom: 12.h,
          left: 14.h,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 12.h),
          child: CustomImageView(
            imagePath: suffixIconPath ?? ImageConstant.imgSearchGreen500,
            height: 22.h,
            width: 24.h,
            fit: BoxFit.contain,
          ),
        ),
        suffixIconConstraints: BoxConstraints(
          maxHeight: 22.h,
          maxWidth: 24.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: borderColor ?? Color(0xFFD1D5DB),
            width: 1.h,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: borderColor ?? Color(0xFFD1D5DB),
            width: 1.h,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: borderColor ?? Color(0xFFD1D5DB),
            width: 1.h,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: appTheme.colorFFEF44,
            width: 1.h,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: appTheme.colorFFEF44,
            width: 1.h,
          ),
        ),
      ),
    );
  }
}
