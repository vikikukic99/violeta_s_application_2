import 'package:flutter/material.dart';

import '../core/app_export.dart';

class CustomCheckboxButton extends StatelessWidget {
  CustomCheckboxButton({
    Key? key,
    this.alignment,
    this.isRightCheck,
    this.iconSize,
    this.value,
    required this.onChange,
    this.decoration,
    this.text,
    this.width,
    this.padding,
    this.textStyle,
    this.overflow,
    this.textAlignment,
  }) : super(key: key);

  final Alignment? alignment;
  final bool? isRightCheck;
  final double? iconSize;
  final bool? value;
  final Function(bool) onChange;
  final BoxDecoration? decoration;
  final String? text;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final TextOverflow? overflow;
  final TextAlign? textAlignment;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildCheckBoxWidget)
        : buildCheckBoxWidget;
  }

  Widget get buildCheckBoxWidget => InkWell(
        onTap: () {
          onChange(!(value!));
        },
        child: Container(
          decoration: decoration,
          width: width,
          child: (isRightCheck ?? false) ? rightSideCheckbox : leftSideCheckbox,
        ),
      );

  Widget get leftSideCheckbox => Row(
        children: [
          Padding(
            child: checkboxWidget,
            padding: EdgeInsets.only(right: 8.h),
          ),
          Expanded(
            child: textWidget,
          ),
        ],
      );

  Widget get rightSideCheckbox => Row(
        children: [
          Expanded(
            child: textWidget,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: checkboxWidget,
          ),
        ],
      );

  Widget get textWidget => Text(
        text ?? "",
        textAlign: textAlignment ?? TextAlign.left,
        overflow: overflow,
        style: textStyle ?? TextStyle(fontSize: 14, color: Colors.grey[600]),
      );

  Widget get checkboxWidget => Container(
        height: iconSize ?? 20.h,
        width: iconSize ?? 20.h,
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          color: (value ?? false) ? appTheme.green_500 : Colors.transparent,
          border: Border.all(
            color: (value ?? false) ? appTheme.green_500 : appTheme.gray_600,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4.h),
        ),
        child: (value ?? false)
            ? Icon(
                Icons.check,
                color: appTheme.white_A700,
                size: (iconSize ?? 20.h) - 6.h,
              )
            : Container(),
      );
}