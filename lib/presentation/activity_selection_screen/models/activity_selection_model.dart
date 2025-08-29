import '../../../core/app_export.dart';

/// This class is used in the [activity_selection_screen] screen.

// ignore_for_file: must_be_immutable
class ActivitySelectionModel extends Equatable {
  ActivitySelectionModel({
    this.selectedLocation,
    this.selectedTime,
    this.description,
    this.id,
  }) {
    selectedLocation = selectedLocation ?? '';
    selectedTime = selectedTime ?? '';
    description = description ?? '';
    id = id ?? '';
  }

  String? selectedLocation;
  String? selectedTime;
  String? description;
  String? id;

  ActivitySelectionModel copyWith({
    String? selectedLocation,
    String? selectedTime,
    String? description,
    String? id,
  }) {
    return ActivitySelectionModel(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedTime: selectedTime ?? this.selectedTime,
      description: description ?? this.description,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [selectedLocation, selectedTime, description, id];
}
