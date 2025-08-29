import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

/// This class is used for activity preferences in the edit profile screen.

// ignore_for_file: must_be_immutable
class ActivityPreferenceModel extends Equatable {
  ActivityPreferenceModel({
    this.activityName,
    this.icon,
    this.isSelected,
  }) {
    activityName = activityName ?? '';
    icon = icon ?? Icons.local_activity;
    isSelected = isSelected ?? false;
  }

  String? activityName;
  IconData? icon;
  bool? isSelected;

  ActivityPreferenceModel copyWith({
    String? activityName,
    IconData? icon,
    bool? isSelected,
  }) {
    return ActivityPreferenceModel(
      activityName: activityName ?? this.activityName,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [activityName, icon, isSelected];
}
