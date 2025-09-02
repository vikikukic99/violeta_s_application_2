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

  /// NEW: normalized activity category used for filtering
  /// Allowed values in this app: 'Walking', 'Running', 'Cycling', 'Dog Walking'
  String? category;

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
    this.category, // NEW
  }) {
    iconPath = iconPath ?? '';
    iconBackgroundColor = iconBackgroundColor ?? const Color(0xFF4CAF50);
    title = title ?? '';
    location = location ?? '';
    status = status ?? '';
    statusBackgroundColor = statusBackgroundColor ?? const Color(0x33FFD54F);
    statusTextColor = statusTextColor ?? const Color(0xFFFF8F00);
    leaderImage = leaderImage ?? '';
    leaderName = leaderName ?? '';
    category = _normalizeCategory(category ?? 'Walking');
  }

  /// Ensure we keep category values consistent
  String _normalizeCategory(String raw) {
    final v = raw.trim().toLowerCase();
    if (v.contains('run')) return 'Running';
    if (v.contains('cycl')) return 'Cycling';
    if (v.contains('dog')) return 'Dog Walking';
    return 'Walking';
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
        category, // NEW
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
    String? category, // NEW
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
      category: category ?? this.category, // NEW
    );
  }
}
