part of 'profile_notifier.dart';

class ProfileState extends Equatable {
  final ProfileModel? profileModel;
  final List<ActivityChipModel>? activityChips;
  final List<RecentActivityModel>? recentActivities;
  final bool isLoading;

  const ProfileState({
    this.profileModel,
    this.activityChips,
    this.recentActivities,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [
        profileModel,
        activityChips,
        recentActivities,
        isLoading,
      ];

  ProfileState copyWith({
    ProfileModel? profileModel,
    List<ActivityChipModel>? activityChips,
    List<RecentActivityModel>? recentActivities,
    bool? isLoading,
  }) {
    return ProfileState(
      profileModel: profileModel ?? this.profileModel,
      activityChips: activityChips ?? this.activityChips,
      recentActivities: recentActivities ?? this.recentActivities,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
