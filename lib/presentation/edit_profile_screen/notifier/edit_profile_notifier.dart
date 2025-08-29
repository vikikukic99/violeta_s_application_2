import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/activity_preference_model.dart';
import '../models/edit_profile_model.dart';

part 'edit_profile_state.dart';

final editProfileNotifierProvider =
    StateNotifierProvider.autoDispose<EditProfileNotifier, EditProfileState>(
  (ref) => EditProfileNotifier(
    EditProfileState(
      editProfileModel: EditProfileModel(),
    ),
  ),
);

// Keep the old provider for backward compatibility
final editProfileNotifier = editProfileNotifierProvider;

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  EditProfileNotifier(EditProfileState state) : super(state) {
    initialize();
  }

  void initialize() {
    final activityPreferences = [
      ActivityPreferenceModel(
        activityName: 'Walking',
        icon: Icons.directions_walk,
        isSelected: true,
      ),
      ActivityPreferenceModel(
        activityName: 'Cycling',
        icon: Icons.directions_bike,
        isSelected: true,
      ),
      ActivityPreferenceModel(
        activityName: 'Dog Walking',
        icon: Icons.pets,
        isSelected: true,
      ),
      ActivityPreferenceModel(
        activityName: 'Running',
        icon: Icons.directions_run,
        isSelected: true,
      ),
    ];

    state = state.copyWith(
      fullNameController: TextEditingController(text: 'Sarah Johnson'),
      usernameController: TextEditingController(text: 'sarahwalks'),
      isLoading: false,
      editProfileModel: EditProfileModel(
        profileImage: ImageConstant.imgImg104x104,
        fullName: 'Sarah Johnson',
        username: 'sarahwalks',
        bio:
            'Avid hiker and nature enthusiast. I love exploring new trails and meeting fellow walkers. Based in Portland, OR.',
        location: 'Portland, OR',
        activityPreferences: activityPreferences,
      ),
    );
  }

  void toggleActivitySelection(int index) {
    final activities = state.editProfileModel?.activityPreferences;
    if (activities != null && index < activities.length) {
      final updatedActivities = List<ActivityPreferenceModel>.from(activities);
      updatedActivities[index] = updatedActivities[index].copyWith(
        isSelected: !updatedActivities[index].isSelected!,
      );

      state = state.copyWith(
        editProfileModel: state.editProfileModel?.copyWith(
          activityPreferences: updatedActivities,
        ),
      );
    }
  }

  void saveProfile({
    required String name,
    required String username,
    required String bio,
  }) {
    state = state.copyWith(
      editProfileModel: state.editProfileModel?.copyWith(
        fullName: name,
        username: username,
        bio: bio,
      ),
      isSuccess: true,
    );
  }

  void toggleActivityPreference(ActivityPreferenceModel activity) {
    final updatedPreferences =
        state.editProfileModel?.activityPreferences?.map((pref) {
      if (pref.activityName == activity.activityName) {
        return pref.copyWith(
          isSelected: !(pref.isSelected ?? false),
        );
      }
      return pref;
    }).toList();

    state = state.copyWith(
      editProfileModel: state.editProfileModel?.copyWith(
        activityPreferences: updatedPreferences,
      ),
    );
  }

  Future<void> saveChanges() async {
    state = state.copyWith(isLoading: true);

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 1));

      // Update the model with form values
      state = state.copyWith(
        editProfileModel: state.editProfileModel?.copyWith(
          fullName: state.fullNameController?.text,
          username: state.usernameController?.text,
        ),
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save changes',
      );
    }
  }
}