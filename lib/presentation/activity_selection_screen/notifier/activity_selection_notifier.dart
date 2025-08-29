import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/activity_model.dart';
import '../models/activity_selection_model.dart';

part 'activity_selection_state.dart';

final activitySelectionNotifier = StateNotifierProvider.autoDispose<
    ActivitySelectionNotifier, ActivitySelectionState>(
  (ref) => ActivitySelectionNotifier(
    ActivitySelectionState(
      activitySelectionModel: ActivitySelectionModel(),
    ),
  ),
);

class ActivitySelectionNotifier extends StateNotifier<ActivitySelectionState> {
  ActivitySelectionNotifier(ActivitySelectionState state) : super(state) {
    initialize();
  }

  void initialize() {
    final activities = [
      ActivityModel(
        id: '1',
        title: 'Walking',
        iconPath: ImageConstant.imgIGreen500,
        isSelected: true,
      ),
      ActivityModel(
        id: '2',
        title: 'Dog Walking',
        iconPath: ImageConstant.imgIGray600,
        isSelected: false,
      ),
      ActivityModel(
        id: '3',
        title: 'Cycling',
        iconPath: ImageConstant.imgIGray60048x48,
        isSelected: false,
      ),
      ActivityModel(
        id: '4',
        title: 'Running',
        iconPath: ImageConstant.imgIGreen50048x48,
        isSelected: true,
      ),
    ];

    state = state.copyWith(
      activitiesList: activities,
      timeController: TextEditingController(text: '10:00'),
      descriptionController: TextEditingController(),
    );
  }

  void toggleActivitySelection(ActivityModel activity) {
    final updatedActivities = state.activitiesList?.map((item) {
      if (item.id == activity.id) {
        return item.copyWith(isSelected: !(item.isSelected ?? false));
      }
      return item;
    }).toList();

    state = state.copyWith(activitiesList: updatedActivities);
  }

  void setSelectedTime(TimeOfDay time) {
    final timeString =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    state.timeController?.text = timeString;
    state = state.copyWith(selectedTime: time);
  }

  void setStartNow() {
    final now = TimeOfDay.now();
    setSelectedTime(now);
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please tell us more about yourself';
    }
    if (value.trim().length < 10) {
      return 'Please provide at least 10 characters';
    }
    return null;
  }

  void submitForm() {
    final selectedActivities = state.activitiesList
        ?.where((activity) => activity.isSelected ?? false)
        .toList();

    state = state.copyWith(
      isFormSubmitted: true,
      selectedActivitiesCount: selectedActivities?.length ?? 0,
    );

    // Clear form after successful submission
    state.descriptionController?.clear();
    state.timeController?.text = '10:00';
  }
}
