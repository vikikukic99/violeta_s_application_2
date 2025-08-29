import '../../../core/app_export.dart';
import '../models/activity_chip_model.dart';
import '../models/profile_model.dart';
import '../models/recent_activity_model.dart';

part 'profile_state.dart';

final profileNotifierProvider =
    StateNotifierProvider.autoDispose<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(
    ProfileState(
      profileModel: ProfileModel(),
      activityChips: [],
      recentActivities: [],
    ),
  ),
);

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(ProfileState state) : super(state) {
    initialize();
  }

  void initialize() {
    final profileData = ProfileModel(
      profileImage: ImageConstant.imgImg104x104,
      userName: 'Sarah Johnson',
      userHandle: '@sarahjwalk',
      aboutText:
          'Hiking enthusiast and nature lover. I enjoy organizing group walks and discovering new trails. Join me for the next adventure in the great outdoors! 🌲🥾',
    );

    final activityChipsList = [
      ActivityChipModel(
        icon: ImageConstant.imgVectorBlueA700,
        title: 'Cycling',
        backgroundColor: appTheme.gray_100_01,
        textColor: appTheme.blue_A700,
      ),
      ActivityChipModel(
        icon: ImageConstant.imgVector,
        title: 'Walking',
        backgroundColor: appTheme.gray_100_02,
        textColor: appTheme.green_700,
      ),
      ActivityChipModel(
        icon: ImageConstant.imgVectorAmber500,
        title: 'Running',
        backgroundColor: appTheme.yellow_50,
        textColor: appTheme.amber_500,
      ),
    ];

    final recentActivitiesList = [
      RecentActivityModel(
        icon: ImageConstant.imgVectorBlueA700,
        title: 'Cycling Night',
        subtitle: 'Organized • 2 days ago',
        status: 'Completed',
        statusBackgroundColor: appTheme.green_50,
        statusTextColor: appTheme.green_700,
        iconBackgroundColor: appTheme.blue_50_01,
        joinedCount: '1 joined',
        location: 'Blue Ridge Mountains',
      ),
    ];

    state = state.copyWith(
      profileModel: profileData,
      activityChips: activityChipsList,
      recentActivities: recentActivitiesList,
    );
  }

  void updateProfile(ProfileModel updatedProfile) {
    state = state.copyWith(profileModel: updatedProfile);
  }
}
