import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ActivityItemModel extends Equatable {
  String? iconPath;
  Color? iconBackgroundColor;
  String? title;
  String? location;
  String? status;
  Color? statusBackgroundColor;
  Color? statusTextColor;
  String? leaderImage;
  String? leaderName;

  ActivityItemModel({
    this.iconPath,
    this.iconBackgroundColor,
    this.title,
    this.location,
    this.status,
    this.statusBackgroundColor,
    this.statusTextColor,
    this.leaderImage,
    this.leaderName,
  }) {
    iconPath = iconPath ?? '';
    iconBackgroundColor = iconBackgroundColor ?? Color(0xFF4CAF50);
    title = title ?? '';
    location = location ?? '';
    status = status ?? '';
    statusBackgroundColor = statusBackgroundColor ?? Color(0x33FFD54F);
    statusTextColor = statusTextColor ?? Color(0xFFFF8F00);
    leaderImage = leaderImage ?? '';
    leaderName = leaderName ?? '';
  }

  @override
  List<Object?> get props => [
        iconPath,
        iconBackgroundColor,
        title,
        location,
        status,
        statusBackgroundColor,
        statusTextColor,
        leaderImage,
        leaderName,
      ];

  ActivityItemModel copyWith({
    String? iconPath,
    Color? iconBackgroundColor,
    String? title,
    String? location,
    String? status,
    Color? statusBackgroundColor,
    Color? statusTextColor,
    String? leaderImage,
    String? leaderName,
  }) {
    return ActivityItemModel(
      iconPath: iconPath ?? this.iconPath,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      title: title ?? this.title,
      location: location ?? this.location,
      status: status ?? this.status,
      statusBackgroundColor:
          statusBackgroundColor ?? this.statusBackgroundColor,
      statusTextColor: statusTextColor ?? this.statusTextColor,
      leaderImage: leaderImage ?? this.leaderImage,
      leaderName: leaderName ?? this.leaderName,
    );
  }
}
