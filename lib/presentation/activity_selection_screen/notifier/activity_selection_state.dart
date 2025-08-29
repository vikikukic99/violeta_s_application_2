part of 'activity_selection_notifier.dart';

class ActivitySelectionState extends Equatable {
  final ActivitySelectionModel? activitySelectionModel;
  final List<ActivityModel>? activitiesList;
  final TextEditingController? timeController;
  final TextEditingController? descriptionController;
  final TimeOfDay? selectedTime;
  final bool isFormSubmitted;
  final int selectedActivitiesCount;

  const ActivitySelectionState({
    this.activitySelectionModel,
    this.activitiesList,
    this.timeController,
    this.descriptionController,
    this.selectedTime,
    this.isFormSubmitted = false,
    this.selectedActivitiesCount = 0,
  });

  @override
  List<Object?> get props => [
        activitySelectionModel,
        activitiesList,
        timeController,
        descriptionController,
        selectedTime,
        isFormSubmitted,
        selectedActivitiesCount,
      ];

  ActivitySelectionState copyWith({
    ActivitySelectionModel? activitySelectionModel,
    List<ActivityModel>? activitiesList,
    TextEditingController? timeController,
    TextEditingController? descriptionController,
    TimeOfDay? selectedTime,
    bool? isFormSubmitted,
    int? selectedActivitiesCount,
  }) {
    return ActivitySelectionState(
      activitySelectionModel:
          activitySelectionModel ?? this.activitySelectionModel,
      activitiesList: activitiesList ?? this.activitiesList,
      timeController: timeController ?? this.timeController,
      descriptionController:
          descriptionController ?? this.descriptionController,
      selectedTime: selectedTime ?? this.selectedTime,
      isFormSubmitted: isFormSubmitted ?? this.isFormSubmitted,
      selectedActivitiesCount:
          selectedActivitiesCount ?? this.selectedActivitiesCount,
    );
  }
}
