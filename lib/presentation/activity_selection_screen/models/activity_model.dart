import '../../../core/app_export.dart';

/// This class is used in the [activity_card_widget] component.

// ignore_for_file: must_be_immutable
class ActivityModel extends Equatable {
  ActivityModel({
    this.id,
    this.title,
    this.iconPath,
    this.isSelected,
  }) {
    id = id ?? '';
    title = title ?? '';
    iconPath = iconPath ?? '';
    isSelected = isSelected ?? false;
  }

  String? id;
  String? title;
  String? iconPath;
  bool? isSelected;

  ActivityModel copyWith({
    String? id,
    String? title,
    String? iconPath,
    bool? isSelected,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, title, iconPath, isSelected];
}
