import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_bottom_bar.dart';
import './notifier/profile_notifier.dart';
import './widgets/activity_chip_widget.dart';
import './widgets/recent_activity_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.white_A700,
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
          child: Column(
            children: [
              _buildProfileSection(context),
              SizedBox(height: 24.h),
              _buildActivityChipsSection(context),
              SizedBox(height: 24.h),
              _buildRecentActivitiesSection(context),
              Spacer(),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigation(),
      ),
    );
  }

  /// Section Widget - App Bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 56.h,
      title: 'Profile',
      titleColor: theme.textTheme.headlineSmall?.color,
      profileIcon: ImageConstant.imgIGray600,
      onProfileTap: () => _onTapSettings(context),
      showBackButton: true,
      onBackTap: () => Navigator.pop(context),
    );
  }

  /// Section Widget - Profile
  Widget _buildProfileSection(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(profileNotifierProvider);
        final profileModel = state.profileModel;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            children: [
              // Profile Image
              Container(
                height: 104.h,
                width: 104.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(52.h),
                  border: Border.all(
                    color: appTheme.green_500,
                    width: 2.h,
                  ),
                ),
                child: CustomImageView(
                  imagePath:
                      profileModel?.profileImage ?? ImageConstant.imgImg104x104,
                  height: 104.h,
                  width: 104.h,
                  radius: BorderRadius.circular(52.h),
                ),
              ),
              SizedBox(height: 16.h),
              // User Name
              Text(
                profileModel?.userName ?? 'Sarah Johnson',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: appTheme.blue_gray_900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              // User Handle
              Text(
                profileModel?.userHandle ?? '@sarahjwalk',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: appTheme.blue_gray_700,
                ),
              ),
              SizedBox(height: 12.h),
              // About Text
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: Text(
                  profileModel?.aboutText ??
                      'Hiking enthusiast and nature lover. I enjoy organizing group walks and discovering new trails. Join me for the next adventure in the great outdoors! 🌲🥾',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: appTheme.blue_gray_800,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Section Widget - Activity Chips
  Widget _buildActivityChipsSection(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(profileNotifierProvider);
        final activityChips = state.activityChips ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interests',
              style: theme.textTheme.titleMedium?.copyWith(
                color: appTheme.blue_gray_900,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.h,
              runSpacing: 8.h,
              children: activityChips
                  .map<Widget>(
                    (chip) => ActivityChipWidget(activityChip: chip),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  /// Section Widget - Recent Activities
  Widget _buildRecentActivitiesSection(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(profileNotifierProvider);
        final recentActivities = state.recentActivities ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activities',
              style: theme.textTheme.titleMedium?.copyWith(
                color: appTheme.blue_gray_900,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            ...recentActivities
                .map(
                  (activity) => Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: RecentActivityWidget(),
                  ),
                )
                .toList(),
          ],
        );
      },
    );
  }

  /// Settings button tap
  void _onTapSettings(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.editProfileScreen);
  }
}

/// Bottom navigation menu displayed in the Profile screen
class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    List<CustomBottomBarItem> bottomBarItemList = [
      CustomBottomBarItem(
        iconPath: ImageConstant.imgNavChat,
        title: 'Chat',
        routeName: AppRoutes.chatConversationScreen,
      ),
      CustomBottomBarItem(
        iconPath: ImageConstant.imgFrame,
        title: 'WalkTalk',
        routeName: AppRoutes.nearbyActivitiesScreenInitialPage,
      ),
      CustomBottomBarItem(
        iconPath: ImageConstant.imgNavProfile,
        title: 'Profile',
        routeName: AppRoutes.profileScreen,
      ),
    ];

    return CustomBottomBar(
      bottomBarItemList: bottomBarItemList,
      onChanged: (index) {
        NavigatorService.pushNamed(bottomBarItemList[index].routeName);
      },
      selectedIndex: 2,
      backgroundColor: appTheme.white_A700,
      padding: EdgeInsets.symmetric(horizontal: 70.h, vertical: 14.h),
      height: 84.h,
    );
  }
}
