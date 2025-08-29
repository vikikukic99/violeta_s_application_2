import '../../../core/app_export.dart';
import 'package:flutter/material.dart';

class ActivityChipModel extends Equatable {
  String? icon;
  String? title;
  Color? backgroundColor;
  Color? textColor;

  ActivityChipModel({
    this.icon,
    this.title,
    this.backgroundColor,
    this.textColor,
  }) {
    icon = icon ?? '';
    title = title ?? '';
    backgroundColor = backgroundColor ?? Color(0xFFEFF6FF);
    textColor = textColor ?? Color(0xFF2563EB);
  }

  @override
  List<Object?> get props => [
        icon,
        title,
        backgroundColor,
        textColor,
      ];

  ActivityChipModel copyWith({
    String? icon,
    String? title,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ActivityChipModel(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
    );
  }
}
