import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import './notifier/profile_notifier.dart';
import './widgets/activity_chip_widget.dart';
import './widgets/recent_activity_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key, this.showLocalBottomBar = true})
      : super(key: key);

  final bool showLocalBottomBar;

  void _safeBack(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    if (canPop) {
      NavigatorService.goBack();
    } else {
      NavigatorService.pushNamed(AppRoutes.nearbyActivitiesScreen);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileNotifierProvider);
    final profile = state.profileModel;
    final chips = state.activityChips ?? [];
    final recent = state.recentActivities ?? [];

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray_50,

        // HEADER
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appTheme.white_A700,
          centerTitle: true,
          toolbarHeight: 64.h,
          automaticallyImplyLeading: false,
          leading: IconButton(
            tooltip: 'Back',
            icon: Icon(Icons.chevron_left,
                color: appTheme.blue_gray_900, size: 28.h),
            onPressed: () => _safeBack(context),
          ),
          title: Text(
            'Profile',
            style: TextStyleHelper.instance.title20SemiBoldPoppins
                .copyWith(color: appTheme.blue_gray_900),
          ),
          actions: [
            IconButton(
              tooltip: 'More',
              icon: Icon(Icons.more_vert,
                  color: appTheme.blue_gray_900, size: 20.h),
              onPressed: () =>
                  NavigatorService.pushNamed(AppRoutes.editProfileScreen),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(height: 1.h, color: appTheme.blue_gray_100),
          ),
        ),

        // BODY
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 120.h,
                  height: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: appTheme.white_A700, width: 4.h),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(31),
                        offset: const Offset(0, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CustomImageView(
                      imagePath:
                          profile?.profileImage ?? ImageConstant.imgImg104x104,
                      height: 120.h,
                      width: 120.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Name & handle
              Align(
                alignment: Alignment.center,
                child: Text(
                  profile?.userName ?? 'Sarah Johnson',
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.instance.headline24BoldPoppins
                      .copyWith(color: appTheme.blue_gray_900),
                ),
              ),
              SizedBox(height: 6.h),
              Align(
                alignment: Alignment.center,
                child: Text(
                  profile?.userHandle ?? '@sarahjwalk',
                  textAlign: TextAlign.center,
                  style: TextStyleHelper.instance.title16RegularPoppins
                      .copyWith(color: appTheme.gray_600),
                ),
              ),

              // Edit Profile
              SizedBox(height: 16.h),
              Center(
                child: CustomButton(
                  text: 'Edit Profile',
                  onPressed: () =>
                      NavigatorService.pushNamed(AppRoutes.editProfileScreen),
                  backgroundColor: appTheme.green_500,
                  textColor: appTheme.white_A700,
                  leftIcon: ImageConstant.imgFrameGray600,
                  padding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.h),
                  borderRadius: 22.h,
                ),
              ),

              // About
              SizedBox(height: 24.h),
              Text(
                'About',
                style: TextStyleHelper.instance.title20SemiBoldPoppins
                    .copyWith(color: appTheme.blue_gray_900),
              ),
              SizedBox(height: 8.h),
              Text(
                profile?.aboutText ??
                    'Hiking enthusiast and nature lover. I enjoy organizing group walks '
                        'and discovering new trails. Join me for the next adventure in the great outdoors! 🌲🥾',
                style: TextStyleHelper.instance.body14RegularPoppins
                    .copyWith(color: appTheme.blue_gray_800, height: 1.5),
                textAlign: TextAlign.left,
              ),

              // Favorite Activities
              SizedBox(height: 24.h),
              Text(
                'Favorite Activities',
                style: TextStyleHelper.instance.title20SemiBoldPoppins
                    .copyWith(color: appTheme.blue_gray_900),
              ),
              SizedBox(height: 12.h),
              if (chips.isNotEmpty)
                Wrap(
                  spacing: 12.h,
                  runSpacing: 12.h,
                  children: chips
                      .map((chip) => ActivityChipWidget(activityChip: chip))
                      .toList(),
                )
              else
                Text(
                  'No activities yet.',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(color: appTheme.gray_600),
                ),

              // Recent Activities
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activities',
                    style: TextStyleHelper.instance.title20SemiBoldPoppins
                        .copyWith(color: appTheme.blue_gray_900),
                  ),
                  GestureDetector(
                    onTap: () {
                      NavigatorService.pushNamed(
                          AppRoutes.nearbyActivitiesScreen);
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
              if (recent.isNotEmpty)
                ...recent
                    .map((activity) => RecentActivityWidget(activity: activity))
                    .toList()
              else
                Text(
                  'No recent activities.',
                  style: TextStyleHelper.instance.body12RegularInter
                      .copyWith(color: appTheme.gray_600),
                ),

              SizedBox(height: 24.h),
            ],
          ),
        ),

        // Conditionally show bottom navigation bar
        bottomNavigationBar: showLocalBottomBar
            ? CustomBottomBar(
                selectedIndex: 2, // Profile is selected
                onChanged: (index) =>
                    CustomBottomBar.handleNavigation(context, index),
              )
            : null,
      ),
    );
  }
}
