import '../../../core/app_export.dart';
import './activity_preference_model.dart';

/// This class is used in the [edit_profile_screen] screen.

// ignore_for_file: must_be_immutable
class EditProfileModel extends Equatable {
  EditProfileModel({
    this.profileImage,
    this.fullName,
    this.username,
    this.bio,
    this.location,
    this.activityPreferences,
  }) {
    profileImage = profileImage ?? ImageConstant.imgImg104x104;
    fullName = fullName ?? 'Sarah Johnson';
    username = username ?? 'sarahwalks';
    bio = bio ??
        'Avid hiker and nature enthusiast. I love exploring new trails and meeting fellow walkers. Based in Portland, OR.';
    location = location ?? 'Portland, OR';
    activityPreferences = activityPreferences ?? [];
  }

  String? profileImage;
  String? fullName;
  String? username;
  String? bio;
  String? location;
  List<ActivityPreferenceModel>? activityPreferences;

  EditProfileModel copyWith({
    String? profileImage,
    String? fullName,
    String? username,
    String? bio,
    String? location,
    List<ActivityPreferenceModel>? activityPreferences,
  }) {
    return EditProfileModel(
      profileImage: profileImage ?? this.profileImage,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      activityPreferences: activityPreferences ?? this.activityPreferences,
    );
  }

  @override
  List<Object?> get props => [
        profileImage,
        fullName,
        username,
        bio,
        location,
        activityPreferences,
      ];
}
