import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_app_bar.dart'; // Add this import
import './notifier/profile_notifier.dart';
import './widgets/activity_chip_widget.dart';
import './widgets/recent_activity_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileNotifierProvider);
    final profile = state.profileModel;
    final chips = state.activityChips ?? [];
    final recent = state.recentActivities ?? [];

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_50,
        appBar: CustomAppBar(
          title: 'Profile',
          profileIcon: ImageConstant.imgFrameGray600, // settings/gear
          onProfileTap: () =>
              NavigatorService.pushNamed(AppRoutes.editProfileScreen),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 104.h,
                width: 104.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(52.h),
                  border: Border.all(color: appTheme.green_500, width: 2.h),
                ),
                child: CustomImageView(
                  imagePath:
                      profile?.profileImage ?? ImageConstant.imgImg104x104,
                  radius: BorderRadius.circular(52.h),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                profile?.userName ?? 'Sarah Johnson',
                style: TextStyleHelper.instance.headline24BoldPoppins,
              ),
              Text(
                profile?.userHandle ?? '@sarahjwalk',
                style: TextStyleHelper.instance.title16RegularPoppins
                    .copyWith(color: appTheme.blue_gray_700),
              ),
              SizedBox(height: 12.h),
              CustomButton(
                text: 'Edit Profile',
                backgroundColor: appTheme.white_A700,
                borderColor: appTheme.green_500,
                textColor: appTheme.green_500,
                leftIcon: ImageConstant.imgFrameGray600,
                onPressed: () =>
                    NavigatorService.pushNamed(AppRoutes.editProfileScreen),
              ),
              SizedBox(height: 16.h),
              Text(
                profile?.aboutText ??
                    'Hiking enthusiast and nature lover. I enjoy organizing group walks and discovering new trails. Join me for the next adventure in the great outdoors! 🌲🥾',
                style: TextStyleHelper.instance.body14RegularPoppins
                    .copyWith(color: appTheme.blue_gray_800),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favorite Activities',
                  style: TextStyleHelper.instance.title16SemiBoldPoppins
                      .copyWith(color: appTheme.blue_gray_900),
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.h,
                runSpacing: 8.h,
                children: chips
                    .map((chip) => ActivityChipWidget(activityChip: chip))
                    .toList(),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activities',
                    style: TextStyleHelper.instance.title16SemiBoldPoppins
                        .copyWith(color: appTheme.blue_gray_900),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to list of all activities if needed
                    },
                    child: Text(
                      'View All',
                      style: TextStyleHelper.instance.body14MediumPoppins
                          .copyWith(color: appTheme.green_500),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ...recent
                  .map((activity) =>
                      RecentActivityWidget(activity: activity))
                  .toList(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
        bottomNavigationBar: _BottomNavBar(),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border(top: BorderSide(color: appTheme.blue_gray_100)),
      ),
      child: Row(
        children: [
          _NavItem(
            label: 'Chat',
            iconPath: ImageConstant.imgNavChat,
            onTap: () =>
                NavigatorService.pushNamed(AppRoutes.chatConversationScreen),
          ),
          _NavItem(
            label: 'WalkTalk',
            iconPath: ImageConstant.imgNavChat, // replace with WalkTalk icon
            onTap: () =>
                NavigatorService.pushNamed(AppRoutes.nearbyActivitiesScreen),
          ),
          _NavItem(
            label: 'Profile',
            iconPath: ImageConstant.imgNavProfile,
            isActive: true,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.label,
    required this.iconPath,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? appTheme.green_500 : appTheme.blue_gray_300;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: iconPath,
                height: 24.h,
                width: 24.h,
                color: color,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyleHelper.instance.body12MediumInter
                    .copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}