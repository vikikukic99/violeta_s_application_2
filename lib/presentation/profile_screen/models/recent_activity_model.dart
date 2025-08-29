import '../../../core/app_export.dart';
import 'package:flutter/material.dart';

class RecentActivityModel extends Equatable {
  String? icon;
  String? title;
  String? subtitle;
  String? status;
  Color? statusBackgroundColor;
  Color? statusTextColor;
  Color? iconBackgroundColor;
  String? joinedCount;
  String? location;

  RecentActivityModel({
    this.icon,
    this.title,
    this.subtitle,
    this.status,
    this.statusBackgroundColor,
    this.statusTextColor,
    this.iconBackgroundColor,
    this.joinedCount,
    this.location,
  }) {
    icon = icon ?? '';
    title = title ?? '';
    subtitle = subtitle ?? '';
    status = status ?? '';
    statusBackgroundColor = statusBackgroundColor ?? Color(0xFFDCFCE7);
    statusTextColor = statusTextColor ?? Color(0xFF16A34A);
    iconBackgroundColor = iconBackgroundColor ?? Color(0xFFDBEAFE);
    joinedCount = joinedCount ?? '';
    location = location ?? '';
  }

  @override
  List<Object?> get props => [
        icon,
        title,
        subtitle,
        status,
        statusBackgroundColor,
        statusTextColor,
        iconBackgroundColor,
        joinedCount,
        location,
      ];

  RecentActivityModel copyWith({
    String? icon,
    String? title,
    String? subtitle,
    String? status,
    Color? statusBackgroundColor,
    Color? statusTextColor,
    Color? iconBackgroundColor,
    String? joinedCount,
    String? location,
  }) {
    return RecentActivityModel(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      status: status ?? this.status,
      statusBackgroundColor:
          statusBackgroundColor ?? this.statusBackgroundColor,
      statusTextColor: statusTextColor ?? this.statusTextColor,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      joinedCount: joinedCount ?? this.joinedCount,
      location: location ?? this.location,
    );
  }
}
